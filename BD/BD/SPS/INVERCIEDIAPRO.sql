-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INVERCIEDIAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `INVERCIEDIAPRO`;
DELIMITER $$

CREATE PROCEDURE `INVERCIEDIAPRO`(
# ====================================================================
# ----------------SP DE CIERRE DE DIA PARA INVERSIONES----------------
# ====================================================================
  Par_Fecha     DATE,       -- Fecha del Proceso

  Par_Salida      CHAR(1),      -- Indica si espera un SELECT de salida
  INOUT Par_NumErr    INT(11),      -- Numero de error
    INOUT Par_ErrMen    VARCHAR(400),   -- Descripcion de error

  Par_EmpresaID   INT(11),      -- Numero de Empresa
  /*parametros de auditoria*/
    Aud_Usuario			INT(11),			-- Parametro de Auditoria
    Aud_FechaActual  	DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP  	VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID   	VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion	BIGINT				-- Parametro de Auditoria
    )
TerminaStore: BEGIN

/* Declaracion de Variables */
	DECLARE Var_FechaBatch      DATE;
	DECLARE Var_FecBitaco       DATETIME;
	DECLARE Var_MinutosBit      INT;
	DECLARE Sig_DiaHab          DATE;
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE Fec_Calculo         DATE;
	DECLARE Pro_CierreMesInv    INT;
	DECLARE Fec_Paso            DATE;
	DECLARE Var_Control     VARCHAR(50);    -- Control ID
	DECLARE Var_CliProEsp   INT;
	DECLARE Var_CalcCierreIntReal	CHAR(1);	-- Almacena el valor si se realiza el Calculo del Interes Real en el Cierre de Dia


/* Declaracion de Constantes */
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT;
	DECLARE Pro_CieDiaInv       INT;
	DECLARE Pro_Provision       INT;
	DECLARE Pro_PagoInv         INT;
DECLARE Salida_SI         CHAR(1);
DECLARE Salida_NO         CHAR(1);
    DECLARE Un_DiaHabil		    INT;
	DECLARE InstInversion     	INT(11);
DECLARE NoCliEsp      INT;
DECLARE CliProcEspecifico VARCHAR(20);
    DECLARE ConstanteSI			CHAR(1);

/* Asignacion de Constantes */
SET Cadena_Vacia      := '';
SET Fecha_Vacia       := '1900-01-01';
SET Entero_Cero       := 0;
SET Pro_CieDiaInv     := 100;
SET Pro_Provision     := 110;
SET Pro_PagoInv       := 111;
	SET Pro_CierreMesInv    := 112; 			-- Proceso Batch de INVERSIONES pase a Historico de Inversiones
SET Salida_SI         := 'S';       -- Salida: SI
SET Salida_NO           := 'N';       -- Salida: NO
    SET Un_DiaHabil			:= 1;				-- Un Dia Habil
	SET InstInversion   	:= 13;				-- Numero de Instrumento de Inversiones
SET NoCliEsp      :=24;       -- Cliente CrediClub
SET CliProcEspecifico :='CliProcEspecifico';
SET ConstanteSI			:= 'S';				-- Constante: SI

	SET Aud_FechaActual     := NOW();
	SET Var_FecBitaco       := NOW();

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
          SET Par_NumErr  := 999;
          SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al
          concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-INVERCIEDIAPRO');
          SET Var_Control := 'sqlException';
        END;

    SELECT ValorParametro INTO Var_CliProEsp
        FROM PARAMGENERALES
        where LlaveParametro= CliProcEspecifico;

	SELECT Fecha INTO Var_FechaBatch
		FROM BITACORABATCH
      WHERE Fecha       = Par_Fecha
		  AND ProcesoBatchID    = Pro_CieDiaInv;

	SET Var_FechaBatch := IFNULL(Var_FechaBatch, Fecha_Vacia);


	IF Var_FechaBatch != Fecha_Vacia THEN
		LEAVE TerminaStore;
	END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual := NOW();
	CALL BITACORABATCHALT(
      Pro_CieDiaInv,    Par_Fecha,      Var_MinutosBit,   Par_EmpresaID,    Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

	SET Var_FecBitaco := NOW();

    -- -------------------------------------------------------------------------------------------
    -- Vencimiento y Pago de Inversiones
    -- -------------------------------------------------------------------------------------------
        IF (Var_CliProEsp = NoCliEsp) THEN

      CALL INVERPAGOCIERRE024(
        Par_Fecha,      Par_EmpresaID,        Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,   Aud_Sucursal,         Aud_NumTransaccion);

        ELSE

	CALL INVERPAGOCIERRE(
        Par_Fecha,      Par_EmpresaID,        Aud_Usuario,      Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

        END IF;

	SET Var_MinutosBit := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
	SET Aud_FechaActual := NOW();
	CALL BITACORABATCHALT(
      Pro_PagoInv,    Par_Fecha,        Var_MinutosBit,   Par_EmpresaID,    Aud_Usuario,
		Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
    SET Var_FecBitaco = NOW();

    -- -------------------------------------------------------------------------------------------
    -- Proceso que Paga las Inversiones, y hace las Reinversiones
    -- -------------------------------------------------------------------------------------------

	CALL INVERSIONMASIVA(
      Par_Fecha,      Par_EmpresaID,      Salida_NO,      Par_NumErr,     Par_ErrMen,
            Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,   Aud_Sucursal,
            Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
      LEAVE ManejoErrores;
    END IF;

        -- -------------------------------------------------------------------------------------------
    -- Proceso para el Calculo del Interes Real
    -- -------------------------------------------------------------------------------------------
	SET Var_CalcCierreIntReal := (SELECT CalcCierreIntReal FROM CONSTANCIARETPARAMS LIMIT 1);
	SET Var_CalcCierreIntReal := IFNULL(Var_CalcCierreIntReal,Cadena_Vacia);
	-- ==================== INICIA PROCESO PARA EL CAULCULO DEL INTERES REAL =====================
	IF(Var_CalcCierreIntReal = ConstanteSI)THEN
		CALL CALCULOINTERESREALPRO (
			 Par_Fecha,			InstInversion,		Salida_NO,			Par_NumErr,			Par_ErrMen,
			 Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,
			 Aud_Sucursal,		Aud_NumTransaccion);

         IF (Par_NumErr <> Entero_Cero)THEN
      		LEAVE ManejoErrores;
		END IF;
	END IF;
	-- ==================== FINALIZA PROCESO PARA EL CAULCULO DEL INTERES REAL =====================

    -- -------------------------------------------------------------------------------------------
    --  Proceso para el pago periodico de inversiones
    -- -------------------------------------------------------------------------------------------
    CALL INVERPAGCIEDIAPRE(
        Par_Fecha,        Salida_NO,        Par_NumErr,       Par_ErrMen,       Par_EmpresaID,
        Aud_Usuario,      Aud_FechaActual,      Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

    IF (Par_NumErr <> Entero_Cero)THEN
      LEAVE ManejoErrores;
	END IF;

    -- -------------------------------------------------------------------------------------------
    -- Proceso para saber si el siguiente dia es habil
    -- -------------------------------------------------------------------------------------------

	CALL DIASFESTIVOSCAL(
      Par_Fecha,      Un_DiaHabil,              Sig_DiaHab,          Var_EsHabil,       Par_EmpresaID,
		Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
		Aud_NumTransaccion);

    SET Fec_Calculo := Par_Fecha;


	WHILE (Fec_Calculo < Sig_DiaHab) DO

    -- -------------------------------------------------------------------------------------------
    -- Proceso que Genera el Interes Provisionado del Dia
    -- -------------------------------------------------------------------------------------------

      SET Var_FecBitaco := NOW();
		SET Aud_FechaActual := NOW();

		CALL INVERPROVISIONPRO(
        Fec_Calculo,  Par_EmpresaID,     Aud_Usuario,   Aud_FechaActual,  Aud_DireccionIP,
			Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

		SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());
		SET Aud_FechaActual := NOW();

		CALL BITACORABATCHALT(
        Pro_Provision,    Fec_Calculo,    Var_MinutosBit, Par_EmpresaID,    Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

      SET Fec_Paso  := Fec_Calculo;
      SET Fec_Calculo := ADDDATE(Fec_Calculo, 1);

    -- -------------------------------------------------------------------------------------------
    -- Se obtiene saldos de como quedaron las inversiones, para Reporteria
    -- -------------------------------------------------------------------------------------------

      IF (MONTH(Fec_Paso) != MONTH(Fec_Calculo))THEN

        SET Var_FecBitaco := NOW();


			CALL CIERREMESINVERSIONES(
          Fec_Paso,     Par_EmpresaID,     Aud_Usuario,     Aud_FechaActual,     Aud_DireccionIP,
          Aud_ProgramaID,   Aud_Sucursal,    Aud_NumTransaccion
        );


			SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

			CALL BITACORABATCHALT(
          Pro_CierreMesInv,   Fec_Paso,       Var_MinutosBit,   Par_EmpresaID,    Aud_Usuario,
          Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,   Aud_NumTransaccion
        );

        SET Var_FecBitaco = NOW();

		END IF;
	END WHILE;

      SET Par_NumErr    := Entero_Cero;
      SET Par_ErrMen    := 'Cierre de Dia de Inversiones Realizadas Exitosamente.';
      SET Var_Control   := 'inversionID';

END ManejoErrores;
  IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr  AS NumErr,
        Par_ErrMen  AS ErrMen,
                Var_Control AS control;
END IF;

END TerminaStore$$