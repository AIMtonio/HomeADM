-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIERREPLANAHORROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIERREPLANAHORROPRO`;
DELIMITER $$

CREATE PROCEDURE `CIERREPLANAHORROPRO`(
-- ======================================================================
-- SP PARA LA LIBERACION DE FOLIOS DE MANERA AUTOMATICA
-- ======================================================================
	Par_FechaActual		DATE,			-- Fecha Actual para vencer folios

    Par_Salida			CHAR(1),
    INOUT Par_NumErr			INT(11),
    INOUT Par_ErrMen			VARCHAR(400),

    /*Parametros Auditoria*/
    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
)
TerminaStore:BEGIN

	/*Declaracion de Variables*/
    DECLARE PlanAhorroID 	INT(11);
    DECLARE Var_Contador	INT(11);
    DECLARE NumDesbloq		INT(11);
    DECLARE Var_BloqID		INT(11);
	DECLARE Var_CuentaAhoID	BIGINT(12);
    DECLARE Var_FechaMov	DATE;
    DECLARE Var_Monto		DECIMAL(12,2);
    DECLARE Var_RefBloq		BIGINT(20);
    DECLARE Desc_Desbloq	VARCHAR(50);
    DECLARE	Var_MinutosBit 	INT(11);
    DECLARE	Var_FecBitaco 	DATETIME;


	/*Declaracion de Constantes*/
    DECLARE Desbloqueo 		CHAR(1);
    DECLARE Entero_Cero		INT(11);
    DECLARE Estatus_Activo	CHAR(1);
    DECLARE Fecha_Vacia		DATE;
    DECLARE TipoBloqPlanAho	INT(11);
    DECLARE Cadena_Vacia	VARCHAR(50);
    DECLARE Salida_No		CHAR(1);
	DECLARE Pro_CiePlanAho	INT(11);

    /*Asignacion de Constantes*/
    SET Desbloqueo 		:= 'D';
    SET Entero_Cero		:= 0;
    SET Estatus_Activo 	:= 'A';
    SET Fecha_Vacia		:= '1900-01-01';
    SET TipoBloqPlanAho := 19;
    SET Cadena_Vacia 	:= '';
    SET Salida_No		:= 'N';
    SET Pro_CiePlanAho	:= 422;	-- Proceso Batch para la Liberacion de Folios de Plan de Ahorro

    SET Aud_ProgramaID  := 'CIERREPLANAHORROPRO';
    SET Desc_Desbloq	:= 'PROCESO LIBERACION DE PLAN DE AHORRO';

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-CIERREPLANAHORROPRO');
			END;

    SET PlanAhorroID := (SELECT PlanID FROM FOLIOSPLANAHORRO WHERE FechaLiberacion=Par_FechaActual LIMIT 1);
    SET PlanAhorroID := IFNULL(PlanAhorroID,Entero_Cero);
    SET Var_FecBitaco := NOW();

	IF(PlanAhorroID<>Entero_Cero)THEN
		DROP TABLE IF EXISTS TMPFOLIOSPLANAHORRO;
		CREATE TABLE TMPFOLIOSPLANAHORRO(
            `RegistroID` bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
			Consecutivo		INT(11),
            BloqueoID		INT(11),
            CuentaAhoID		BIGINT(12),
            FechaMov		DATE,
            MontoBloq		DECIMAL(12,2),
            ReferenciaBloq	BIGINT(20),
            NumTransaccion	BIGINT(20)
		);
        CREATE INDEX IDX_Consecutivo ON TMPFOLIOSPLANAHORRO (Consecutivo);

        SET @Cont := 0;
        INSERT INTO TMPFOLIOSPLANAHORRO (
						`Consecutivo`,					`BloqueoID`,					`CuentaAhoID`,					`FechaMov`,					`MontoBloq`,
						`ReferenciaBloq`,				`NumTransaccion`)

			SELECT (@Cont:=@Cont+1) AS Consecutivo,	MAX(Blo.BloqueoID),		Fp.CuentaAhoID,		MAX(Fp.Fecha),		MAX(Blo.MontoBloq),
					MAX(Blo.Referencia),			Fp.NumTransaccion
            FROM FOLIOSPLANAHORRO Fp
			     INNER JOIN BLOQUEOS Blo
				    ON Blo.CuentaAhoID = Fp.CuentaAhoID
				    AND DATE(Blo.FechaMov) =  Fp.Fecha
				    AND Blo.NumTransaccion = Fp.NumTransaccion
            WHERE Fp.FechaLiberacion = Par_FechaActual
                AND Fp.Estatus = Estatus_Activo
			GROUP BY Fp.CuentaAhoID,Fp.Fecha,Fp.NumTransaccion
            ORDER BY Consecutivo;

		SET NumDesbloq = (SELECT COUNT(*) FROM TMPFOLIOSPLANAHORRO);
        SET NumDesbloq = IFNULL(NumDesbloq,Entero_Cero);
		SET Var_Contador := 1;
        WHILE(Var_Contador<=NumDesbloq)DO
			SELECT 	BloqueoID, 		CuentaAhoID, 		FechaMov, 		MontoBloq, 	ReferenciaBloq
				INTO Var_BloqID,	Var_CuentaAhoID, 	Var_FechaMov, 	Var_Monto, 	Var_RefBloq
			FROM TMPFOLIOSPLANAHORRO
            WHERE Consecutivo = Var_Contador;

			CALL BLOQUEOSPRO(
				Var_BloqID,			Desbloqueo,			Var_CuentaAhoID,	Var_FechaMov,	Var_Monto,
                Par_FechaActual,	TipoBloqPlanAho,	Desc_Desbloq,		Var_RefBloq,	Cadena_Vacia,
                Cadena_Vacia,		Salida_No,			Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,
                Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
                Aud_NumTransaccion);

            SET Var_Contador := Var_Contador + 1;
        END WHILE;

	END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	CALL BITACORABATCHALT(
		Pro_CiePlanAho,		Par_FechaActual,	Var_MinutosBit,		Aud_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

END ManejoErrores;


END TerminaStore$$
