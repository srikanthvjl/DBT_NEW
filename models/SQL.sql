CREATE PROCEDURE [report].[Bayer_Case_Detail_Report]
 (
	@StartDate DATETIME
	,@EndDate DATETIME
)
AS
/*-------------------------------------------------------------------------------------------------------------------------------------
Procedure Name	:	[report].[Bayer_Case_Detail_Report] 
Description		:	Case Detail Report for Bayer

Date Modified	Modified By		Modifications  
10/31/2017      abenita		    Initial Version 
12/08/2017		abenita			Modified mapping for referral date and primary diagnosis
12/12/2017		abenita			Modified the join conditions for table PAPApplication
02/13/2017		abenita			Modified the condition for PAP expiration date
09/20/2018		HarigoppulaH	Use Left join between PatientCases and PatientCases_ext1
09/28/2018      stamil          Removed the 'PatientCases_ext1' join as this table is not used to fetch values or with other join condition.
01/18/2019		abenita			Added a column and modified mapping for RxC BI Completion Date  column as per PBI 54857
10/11/2019		abenita			Modifed/Added column as per PBI 60032

Test Harness:
exec [report].[Bayer_Case_Detail_Report] '2019-01-01', '2019-10-11'
---------------------------------------------------------------------------------------------------------------------------------------------*/
BEGIN
	SET NOCOUNT ON;

	/*To declare local variables*/
	DECLARE @CompanyID VARCHAR(10) = 'RxCRoads'
		,@ClientID VARCHAR(10) = 'Bayer'
		,@ProgramID VARCHAR(10) = 'BetaPlus'
		,@IntakeComplete VARCHAR(10)
		,@BusinessInv DECIMAL
		,@TriageToSPPActId DECIMAL

	SELECT @TriageToSPPActId = CASE 
			WHEN LOWER(ProgActDescription) = 'triage to spp'
				THEN ProgActID
			ELSE @TriageToSPPActId
			END
	FROM dbo.ClientProgramActivity
	WHERE CompanyID = @CompanyID
		AND ClientID = @ClientID
		AND ClientPrgID = @ProgramID

    /*To get Program Milestone ID of  'intake complete'  and 'benefit investigation' */
	SELECT @IntakeComplete = CASE 
			WHEN LOWER(ProgMilestoneDesc) = 'intake complete'
				THEN ProgMilestoneID
			ELSE @IntakeComplete
			END
			,@BusinessInv = CASE 
			WHEN LOWER(ProgMilestoneDesc) = 'benefit investigation'
			    THEN ProgMilestoneID
			ELSE @BusinessInv
			END
	FROM ProgramMilestones
	WHERE CompanyID = @CompanyID
		AND ClientID = @ClientID
		AND ProgramID = @ProgramID
		AND LOWER(ProgMilestoneDesc) IN ('intake complete','benefit investigation')

	
	/*To get Bayer BetaPlus Case Detail Record*/
	SELECT DISTINCT PC.CaseID AS 'Case ID'
		,PC.PatientID AS 'Patient ID'
		,PC.ProgramID AS 'Program'
		,CASE 
			WHEN ISDATE(PC.CaseConsentReceiptDate) = 1
				AND YEAR(PC.CaseConsentReceiptDate) > 1900
				THEN CONVERT(VARCHAR(10), PC.CaseConsentReceiptDate, 101)
			ELSE NULL
			END AS 'Consent Receipt Date'
		,ITS.IntakeStatusDesc AS 'Case Status'
		,ISR.IntakeStatRsnDesc AS 'Case Sub Status'
		,CASE 
			WHEN ISDATE(PC.CaseCreateDateTime) = 1
				AND YEAR(PC.CaseCreateDateTime) > 1900
				THEN CONVERT(VARCHAR(10), PC.CaseCreateDateTime, 101)
			ELSE NULL
			END AS 'Case Create Date'
		,RT.ReferalTypeDesc AS 'Referral Type'
		,CASE 
			WHEN ISDATE(PC.CasePhysSignatureDate) = 1
				AND YEAR(PC.CasePhysSignatureDate) > 1900
				THEN CONVERT(VARCHAR(10), PC.CasePhysSignatureDate, 101)
			ELSE NULL
			END AS 'Referral Date'
		,CASE 
			WHEN ISDATE(PCM.CaseMilestoneInitiateDate) = 1
				AND YEAR(PCM.CaseMilestoneInitiateDate) > 1900
				THEN CONVERT(VARCHAR(10), PCM.CaseMilestoneInitiateDate, 101)
			ELSE NULL
			END AS 'Receipt Date'
		,CASE 
			WHEN ISDATE(PC.CaseIntakeCompleteDate) = 1
				AND YEAR(PC.CaseIntakeCompleteDate) > 1900
				THEN CONVERT(VARCHAR(10), PC.CaseIntakeCompleteDate, 101)
			ELSE NULL
			END AS 'Intake Complete Date'
		,CASE WHEN ISDATE(PCM1.CaseMilestoneCompleteDate) = 1
				AND YEAR(PCM1.CaseMilestoneCompleteDate) > 1900
				THEN CONVERT(VARCHAR(10), PCM1.CaseMilestoneCompleteDate, 101)
			ELSE NULL
			END AS 'RxC BI Completion Date'
		,R.RegionName AS 'Region Name'
		,TER.TerritoryName AS 'Territory Name'
		,'Not available' AS 'Sales Rep First Name'
		,'Not available' AS 'Sales Rep Last Name'
		,PC.CaseHubPhysicianID AS 'RxC Phys ID - MD Prescribing Tab'
		,HP.HubPhysFirstName AS 'Physician First Name'
		,HP.HubPhysLastName AS 'Physician Last Name'
		,dbo.FormatNumeric(HP.HubPhysPhoneNo) AS 'Physician Phone #'
		,HP.HubPhysStateID AS 'Physician State'
		,HP.HubPhysZipCode AS 'Physician Zip Code'
		,HPORG.HubPhysOrgName AS 'MD Org Name'
		,HPORG.HubPhysOrgZipCode AS 'MD Org Zip'
		,HIO.HubInsOrgName AS 'Primary Insurance Co'
		,HIO.InsTypeID AS 'Primary Payer Type'
		,HIP.HubInsPlanName AS 'Primary Insurance Plan'
		,PBM.PBMName AS 'Primary PBM'
		,HIV.HUBPolicyPBMPlanName AS 'Primary Pharmacy Name'
		,ISNULL(CDD10.DiagDtlDiagnosisName, CDD9.DiagDtlDiagnosisName) AS 'Primary Diagnosis'
		,S.UserFirstName + ', ' + S.UserLastName AS 'Case Manager'
		,HPH.HubPharmacyname AS 'Current SPP'
		,CASE 
			WHEN ISDATE(T.TriageDate) = 1 AND YEAR(T.TriageDate) > 1900
				THEN CONVERT(VARCHAR(10), T.TriageDate, 101)
				ELSE NULL
				END AS 'Date Sent to Current SPP'
		,PAP.PapApplStatusID AS 'PAP Status'
		,CASE 
			WHEN ISDATE(PAP.PapApplCompletionDate) = 1
				AND YEAR(PAP.PapApplCompletionDate) > 1900
				THEN CONVERT(VARCHAR(10), PAP.PapApplCompletionDate, 101)
			ELSE NULL
			END AS 'PAP Completion Date'
		,CASE 
			WHEN ISDATE(PAP.PapApplExpirationDate) = 1
				AND YEAR(PAP.PapApplExpirationDate) > 1900
				THEN CONVERT(VARCHAR(10), PAP.PapApplExpirationDate, 101)
			ELSE NULL
			END AS 'PAP Expiration Date'
		,CASE 
			WHEN LOWER(PC.referaltypeid) = 'bridge'
				AND PFH1.FulFilHdrID IS NOT NULL
				THEN 'Yes'
			ELSE 'No'
			END AS 'Bridge Product Shipped'
		,CASE 
			WHEN LOWER(CT.NAME) = 'hipaa'
				THEN 'Yes'
			ELSE 'No'
			END AS 'HIPAA waiver received'
		,PT.TherapyDescription AS 'Enrollment in BetaPlus'
	FROM PatientCases PC
	LEFT JOIN INTAKESTATUS ITS ON ITS.CompanyID = PC.CompanyID
		AND ITS.ClientID = PC.ClientID
		AND ITS.ProgramID = PC.ProgramID
		AND ITS.IntakeStatusID = PC.CaseIntakeStatusID
	LEFT JOIN INTAKESTATREASON ISR ON ISR.CompanyID = ITS.CompanyID
		AND ISR.ClientID = ITS.ClientID
		AND ISR.ProgramID = ITS.ProgramID
		AND ISR.IntakeStatRsnID = PC.CaseIntakeStatusRsn
		AND ISR.IntakeStatRsnStatusID = ITS.IntakeStatusID
	LEFT JOIN REFERALTYPE RT ON RT.CompanyID = PC.CompanyID
		AND RT.ClientID = PC.ClientID
		AND RT.ClientPrgID = PC.ProgramID
		AND RT.ReferalTypeID = PC.ReferalTypeID
	LEFT JOIN HUBPHYSICIAN HP ON HP.CompanyID = PC.CompanyID
		AND HP.ClientID = PC.ClientID
		AND HP.ProgramID = PC.ProgramID
		AND HP.HubPhysID = PC.CaseHubPhysicianID
	LEFT OUTER JOIN HUBPHYSICIANORG HPORG ON HPORG.CompanyID = PC.CompanyID
		AND HPORG.ClientID = PC.ClientID
		AND HPORG.ProgramID = PC.ProgramID
		AND HPORG.HubPhysOrgID = PC.CaseHubPhysOrganizationID
	LEFT JOIN HUBINSURANCEVERIFICATION AS HIV ON HIV.CompanyID = PC.CompanyID
		AND HIV.ClientID = PC.ClientID
		AND HIV.ProgramID = PC.ProgramID
		AND HIV.PatientID = PC.PatientID
		AND HIV.CaseID = PC.CaseID
		AND LOWER(HIV.HubPolicyPayerPriorityID) = 'primary'
	LEFT JOIN HUBINSURANCEORGANIZATION HIO ON HIO.CompanyID = HIV.CompanyID
		AND HIO.ClientID = HIV.ClientID
		AND HIO.ProgramID = HIV.ProgramID
		AND HIO.HubInsOrgID = HIV.HubInsOrgID
	LEFT JOIN HUBINSURANCEPLAN HIP ON HIP.CompanyID = HIV.CompanyID
		AND HIP.ClientID = HIV.ClientID
		AND HIP.ProgramID = HIV.ProgramID
		AND HIP.HubInsOrgID = HIV.HubInsOrgID
		AND HIP.HubInsPlanID = HIV.HubInsPlanID
	LEFT JOIN dbo.pharmacybenefitmanager PBM ON PBM.CompanyID = HIV.CompanyID
		AND PBM.ClientID = HIV.ClientID
		AND PBM.Programid = HIV.ProgramID
		AND PBM.PBMID = HIV.PBMID
	LEFT JOIN Security S ON S.SecurityID = ISNULL(PC.CaseSupportSpecialist, - 1)
	--LEFT OUTER JOIN dbo.patfulfillmentheader PFH ON PFH.CompanyID = PC.CompanyID
	--	AND PFH.ClientID = PC.ClientID
	--	AND PFH.ProgramID = PC.ProgramID
	--	AND PFH.PatientID = PC.PatientID
	--	AND PFH.CaseID = PC.CaseID
	LEFT OUTER JOIN dbo.patfulfillmentheader PFH1 ON PFH1.CompanyID = PC.CompanyID
		AND PFH1.ClientID = PC.ClientID
		AND PFH1.ProgramID = PC.ProgramID
		AND PFH1.PatientID = PC.PatientID
		AND PFH1.CaseID = PC.CaseID
		AND PFH1.FulFilHdrID = (
			SELECT MAX([FulFilHdrID])
			FROM [dbo].[PATFULFILLMENTHEADER] AS PFH2
			WHERE PFH2.CompanyID = PFH1.CompanyID
				AND PFH2.ClientID = PFH1.ClientID
				AND PFH2.ProgramID = PFH1.ProgramID
				AND PFH2.PatientID = PFH1.PatientID
				AND PFH2.CaseID = PFH1.CaseID
			)
	LEFT OUTER JOIN HubPharmacy HPH ON HPH.CompanyID = PC.CompanyID
		AND HPH.ClientID = PC.ClientID
		AND HPH.Programid = PC.ProgramID
		AND HPH.HubPharmOrgID = PC.PharmOrgID
		AND HPH.HubPharmacyID = PC.PharmacyID
	LEFT OUTER JOIN dbo.PAPAPPLICATION PAP ON PAP.CompanyID = PC.CompanyID
		AND PAP.ClientID = PC.ClientID
		AND PAP.ProgramID = PC.ProgramID
		AND PAP.PatientID = PC.PatientID
		AND PAP.CaseID = PC.CaseID
		AND pap.PapApplID = (
				SELECT MAX(PapApplID)
				FROM dbo.PapApplication
				WHERE CompanyID = PC.CompanyID
					AND ClientID = PC.ClientID
					AND ProgramID = PC.ProgramID
					AND PatientID = PC.PatientID
					AND CaseID = PC.CaseID
				)
	LEFT JOIN PatientCaseConsent PCC ON PCC.CompanyID = PC.CompanyID
		AND PCC.ClientID = PC.ClientID
		AND PCC.ProgramID = PC.ProgramID
		AND PCC.PatientID = PC.PatientID
		AND PCC.CaseID = PC.CaseID
	LEFT JOIN Consent C ON C.ConsentId = PCC.ConsentId
	LEFT JOIN [dbo].[ProgramConsentConfiguration] PCCG ON PCCG.CompanyID = PC.CompanyID
		AND PCCG.ClientID = PC.ClientID
		AND PCCG.ProgramID = PC.ProgramID
		AND PCCG.ProgramConsentConfigurationId = C.ProgramConsentConfigurationId
	LEFT JOIN [dbo].[ConsentType] CT ON CT.ConsentTypeId = PCCG.ConsentTypeId
	LEFT JOIN PatientCaseMilestones PCM ON PCM.CompanyID = PC.CompanyID
		AND PCM.ClientID = PC.ClientID
		AND PCM.ProgramID = PC.ProgramID
		AND PCM.PatientID = PC.PatientID
		AND PCM.CaseID = PC.CaseID
		AND PCM.ProgMilestoneID = @IntakeComplete
	LEFT OUTER JOIN dbo.ClinicalDiagnosisDetail CDD10 ON CDD10.CompanyID = PC.CompanyID
		AND CDD10.ClientID = PC.ClientID
		AND CDD10.ProgramID = PC.ProgramID
		AND CDD10.PatientId = PC.PatientID
		AND CDD10.CaseId = PC.CaseID
		AND CDD10.DiagDtlID = (
			SELECT MAX(CDD2.[DiagDtlID])
			FROM [dbo].[ClinicalDiagnosisDetail] AS CDD2
			WHERE CDD2.[CompanyID] = CDD10.CompanyID
				AND CDD2.[ClientID] = CDD10.ClientID
				AND CDD2.[ProgramID] = CDD10.ProgramID
				AND CDD2.[PatientID] = CDD10.PatientID
				AND CDD2.[CaseID] = CDD10.CaseID
				AND CDD2.[DiagDtlDiagnosisPriority] = 'Primary'
				AND CDD10.ClinicalDiagnosisId in (
					SELECT ClinicalDiagnosisId
					FROM CLINICALDIAGNOSIS CD
					WHERE CD.ICDCodeVersion = 10
					    --AND CD.[CompanyID] = CDD2.CompanyID
						--AND CD.[ClientID] = CDD2.ClientID
						--AND CD.[ProgramID] = CDD2.ProgramID	
					)
			)
	LEFT OUTER JOIN dbo.ClinicalDiagnosisDetail CDD9 ON CDD9.CompanyID = PC.CompanyID
		AND CDD9.ClientID = PC.ClientID
		AND CDD9.ProgramID = PC.ProgramID
		AND CDD9.PatientId = PC.PatientID
		AND CDD9.CaseId = PC.CaseID
		AND CDD9.DiagDtlID = (
			SELECT MAX(CDD2.[DiagDtlID])
			FROM [dbo].[ClinicalDiagnosisDetail] AS CDD2
			WHERE CDD2.[CompanyID] = CDD9.CompanyID
				AND CDD2.[ClientID] = CDD9.ClientID
				AND CDD2.[ProgramID] = CDD9.ProgramID
				AND CDD2.[PatientID] = CDD9.PatientID
				AND CDD2.[CaseID] = CDD9.CaseID
				AND CDD2.[DiagDtlDiagnosisPriority] = 'Primary'
				AND CDD9.ClinicalDiagnosisId in (
					SELECT ClinicalDiagnosisId
					FROM CLINICALDIAGNOSIS CD
					WHERE CD.ICDCodeVersion = 9
					    --AND CD.[CompanyID] = CDD2.CompanyID
						--AND CD.[ClientID] = CDD2.ClientID
						--AND CD.[ProgramID] = CDD2.ProgramID	
					)
			)
	LEFT JOIN PatientCaseMileStones PCM1 ON PCM1.CompanyID = PC.companyID
		AND PCM1.ClientID = PC.ClientID
		AND PCM1.ProgramID = PC.ProgramID
		AND PCM1.PatientID = PC.PatientID
		AND PCM1.CaseID = PC.CaseID
		AND PCM1.CaseMileStoneID = (
			SELECT TOP 1 CaseMileStoneID
			FROM PatientCaseMileStones
			WHERE CompanyID = PC.companyID
				AND ClientID = PC.ClientID
				AND ProgramID = PC.ProgramID
				AND PatientID = PC.PatientID
				AND CaseID = PC.CaseID
				AND ProgMilestoneID = @BusinessInv
				ORDER BY CaseMileStoneID DESC
			)
	LEFT OUTER JOIN CaseTherapy CTY ON CTY.companyID = PC.companyID
		AND CTY.ClientID = PC.ClientID
		AND CTY.ProgramID = PC.ProgramID
		AND CTY.PatientId = PC.PatientId
		AND CTY.CaseID = PC.CaseID
		AND CTY.CaseTherapyID = (
			SELECT MAX(CT1.CaseTherapyID) 
			FROM CaseTherapy CT1
			INNER JOIN ProgramTherapy PT ON PT.CompanyID = CT1.CompanyID 
            AND PT.ClientID = CT1.ClientID
            AND PT.ProgramID = CT1.ProgramID
            AND PT.TherapyID = CT1.TherapyID
            INNER JOIN TherapyType TT ON TT.CompanyID = PT.CompanyID
            AND TT.ClientID = PT.ClientID
            AND TT.ProgramID = PT.ProgramID
            AND TT.TherapyTypeID = PT.TherapyTypeID
            AND TT.TherapyTypeDescription = 'Treatment Type'
            WHERE CT1.CompanyID = CTY.CompanyID 
            AND CT1.ClientID = CTY.ClientID
            AND CT1.ProgramID = CTY.ProgramID
            AND CT1.PatientId = CTY.PatientID
            AND CT1.CaseId = CTY.CaseID) 
	LEFT OUTER JOIN ProgramTherapy PT ON PT.CompanyID = CTY.CompanyID 
		AND PT.ClientID = CTY.ClientID
		AND PT.ProgramID = CTY.ProgramID
		AND PT.TherapyID = CTY.TherapyID
	LEFT OUTER JOIN TERRITORY TER ON TER.CompanyID = PC.CompanyID
		AND TER.ClientID = PC.ClientID
		AND TER.ClientPrgID = PC.ProgramID
		AND TER.TerritoryID = PC.CaseTerritoryID
	LEFT JOIN dbo.REGION R WITH (NOLOCK) ON R.CompanyID = TER.CompanyID
		AND R.ClientID = TER.ClientID
		AND R.ClientPrgID = TER.ClientPrgID
		AND R.RegionID = TER.RegionID
		AND R.TerrSetID=TER.TerrSetID
	OUTER APPLY (
		SELECT MAX(pa.PatActCreateDateTime) AS TriageDate
		FROM dbo.PatientActivity pa
		WHERE pa.CompanyID = PC.CompanyID
			AND pa.ClientID = PC.ClientID
			AND pa.ProgramID = PC.ProgramID
			AND pa.PatientID = PC.PatientID
			AND pa.CaseID = PC.CaseID
			AND pa.ProgActID = @TriageToSPPActId
		) T
	WHERE PC.CompanyID = @CompanyID
		AND PC.ClientID = @ClientID
		AND PC.ProgramID = @ProgramID
		AND PC.CaseCreateDateTime >= @StartDate
		AND PC.CaseCreateDateTime < DATEADD(dd, 1, @EndDate)
	ORDER BY pc.patientID
		,pc.caseID
END
