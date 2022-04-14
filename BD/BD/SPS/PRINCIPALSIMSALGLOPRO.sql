-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PRINCIPALSIMSALGLOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PRINCIPALSIMSALGLOPRO`;
DELIMITER $$


CREATE  PROCEDURE `PRINCIPALSIMSALGLOPRO`(

   Par_ConvenioNominaID    BIGINT UNSIGNED,
    Par_Monto               DECIMAL(14,2),
    Par_Tasa                DECIMAL(14,4),
    Par_Frecu               INT(11),
    Par_PagoCuota           CHAR(1),
    Par_PagoFinAni          CHAR(1),

    Par_DiaMes              INT(2),
    Par_FechaInicio         DATE,
    Par_NumeroCuotas        INT(11),
    Par_ProducCreditoID     INT(11),
    Par_ClienteID           INT(11),

    Par_DiaHabilSig         CHAR(1),
    Par_AjustaFecAmo        CHAR(1),
    Par_AjusFecExiVen       CHAR(1),
    Par_ComAper             DECIMAL(14,2),
    Par_MontoGL             DECIMAL(12,2),

    Par_CobraSeguroCuota    CHAR(1),
    Par_CobraIVASeguroCuota CHAR(1),
    Par_MontoSeguroCuota    DECIMAL(12,2),
    Par_ComAnualLin         DECIMAL(12,2),
    Par_Salida              CHAR(1),

    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),
    INOUT   Par_NumTran     BIGINT(20),
    INOUT   Par_Cuotas      INT(11),
    INOUT   Par_Cat         DECIMAL(14,4),
    INOUT   Par_MontoCuo    DECIMAL(14,4),
    INOUT   Par_FechaVen    DATE,


    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN

    DECLARE Var_CliProEsp                           INT;
    DECLARE Var_Control								VARCHAR(50);
    DECLARE Var_ManejaConvenio						CHAR(5);


    DECLARE Decimal_Cero                            DECIMAL(14,2);
    DECLARE Entero_Cero                             INT(11);
    DECLARE Entero_Negativo                         INT(11);
    DECLARE Entero_Uno                              INT(11);
    DECLARE Cadena_Vacia                            CHAR(1);
    DECLARE Var_SI                                  CHAR(1);
    DECLARE Var_No                                  CHAR(1);
    DECLARE PagoSemanal                             CHAR(1);
    DECLARE PagoDecenal                             CHAR(1);
    DECLARE PagoCatorcenal                          CHAR(1);
    DECLARE PagoQuincenal                           CHAR(1);
    DECLARE PagoMensual                             CHAR(1);
    DECLARE PagoPeriodo                             CHAR(1);
    DECLARE PagoBimestral                           CHAR(1);
    DECLARE PagoTrimestral                          CHAR(1);
    DECLARE PagoTetrames                            CHAR(1);
    DECLARE PagoSemestral                           CHAR(1);
    DECLARE PagoAnual                               CHAR(1);
    DECLARE PagoFinMes                              CHAR(1);
    DECLARE PagoAniver                              CHAR(1);
    DECLARE FrecSemanal                             INT(11);
    DECLARE FrecDecenal                             INT(11);
    DECLARE FrecCator                               INT(11);
    DECLARE FrecQuin                                INT(11);
    DECLARE FrecMensual                             INT(11);
    DECLARE FrecBimestral                           INT(11);
    DECLARE FrecTrimestral                          INT(11);
    DECLARE FrecTetrames                            INT(11);
    DECLARE FrecSemestral                           INT(11);
    DECLARE FrecAnual                               INT(11);
    DECLARE Con_CliProcEspe                         VARCHAR(20);
    DECLARE Var_LlaveParametro						VARCHAR(50);
    DECLARE Var_EsProducNomina						CHAR(1);
    DECLARE Var_ManejaCalendario                    CHAR(1);                    -- Maneja calendario
    DECLARE Var_ManejaFechaIniCal                   CHAR(1);                    -- Maneja fecha de inicio de calendario
    DECLARE Var_CienteATE							VARCHAR(200);				-- Maneja cliente especifico de ATE
    DECLARE Var_Cliente								VARCHAR(200);



	SET Var_CienteATE				:= '49';
    SET Decimal_Cero                := 0.00;
    SET Entero_Cero                 := 0;
    SET Entero_Negativo             := -1;
    SET Entero_Uno                  := 1;
    SET Cadena_Vacia                := '';
    SET Var_SI                      := 'S';
    SET Var_No                      := 'N';
    SET PagoSemanal                 := 'S';
    SET PagoDecenal                 := 'D';
    SET PagoCatorcenal              := 'C';
    SET PagoQuincenal               := 'Q';
    SET PagoMensual                 := 'M';
    SET PagoPeriodo                 := 'P';
    SET PagoBimestral               := 'B';
    SET PagoTrimestral              := 'T';
    SET PagoTetrames                := 'R';
    SET PagoSemestral               := 'E';
    SET PagoAnual                   := 'A';
    SET PagoFinMes                  := 'F';
    SET PagoAniver                  := 'A';
    SET Var_LlaveParametro        	:= 'ManejaCovenioNomina';

     ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-PRINCIPALSIMSALGLOPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;


		SELECT ValorParametro INTO Var_ManejaConvenio
			FROM PARAMGENERALES
			WHERE LlaveParametro=Var_LlaveParametro;

		SELECT ProductoNomina INTO Var_EsProducNomina
			FROM PRODUCTOSCREDITO
            WHERE ProducCreditoID = Par_ProducCreditoID;

        SET Var_ManejaConvenio := IFNULL(Var_ManejaConvenio, Var_No);

		SET Var_EsProducNomina := IFNULL(Var_EsProducNomina,Var_No);

        IF(Var_ManejaConvenio = Var_SI AND Var_EsProducNomina = Var_SI)THEN
             -- VALIDA SI EL SE MANEJA CALENDARIO Y CONVENIO DE NOMINA -----------------------------------------------------
            SELECT ManejaCalendario, ManejaFechaIniCal INTO Var_ManejaCalendario, Var_ManejaFechaIniCal
                FROM CONVENIOSNOMINA
            WHERE ConvenioNominaID = Par_ConvenioNominaID;

            SET Var_ManejaCalendario    := IFNULL(Var_ManejaCalendario, Var_No);
            SET Var_ManejaFechaIniCal   := IFNULL(Var_ManejaFechaIniCal, Var_No);

            IF(Var_ManejaCalendario = Var_SI AND Var_ManejaFechaIniCal =  Var_SI)THEN
				SELECT ValorParametro INTO Var_Cliente FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico';
					IF(Var_Cliente = Var_CienteATE)THEN
						CALL CRESIMSALGLOCVNATEPRO(
						Par_ConvenioNominaID,
						Par_Monto,				Par_Tasa,				Par_Frecu,					Par_PagoCuota,					Par_PagoFinAni,
						Par_DiaMes,				Par_FechaInicio,		Par_NumeroCuotas,			Par_ProducCreditoID,			Par_ClienteID,
						Par_DiaHabilSig,		Par_AjustaFecAmo,		Par_AjusFecExiVen,			Par_ComAper,					Par_MontoGL,
						Par_CobraSeguroCuota,	Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,		Par_ComAnualLin,				Par_Salida,
						Par_NumErr,				Par_ErrMen,				Par_NumTran,				Par_Cuotas,						Par_Cat,
						Par_MontoCuo,			Par_FechaVen,			Par_EmpresaID,				Aud_Usuario,					Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
					ELSE
						CALL CRESIMSALGLOCVNPRO(
						Par_ConvenioNominaID,
						Par_Monto,				Par_Tasa,				Par_Frecu,					Par_PagoCuota,					Par_PagoFinAni,
						Par_DiaMes,				Par_FechaInicio,		Par_NumeroCuotas,			Par_ProducCreditoID,			Par_ClienteID,
						Par_DiaHabilSig,		Par_AjustaFecAmo,		Par_AjusFecExiVen,			Par_ComAper,					Par_MontoGL,
						Par_CobraSeguroCuota,	Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,		Par_ComAnualLin,				Par_Salida,
						Par_NumErr,				Par_ErrMen,				Par_NumTran,				Par_Cuotas,						Par_Cat,
						Par_MontoCuo,			Par_FechaVen,			Par_EmpresaID,				Aud_Usuario,					Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
					END IF;
            END IF;

            IF(Var_ManejaFechaIniCal <> Var_SI)THEN

                CALL CRESIMSALGLONOMPRO(
                    Par_ConvenioNominaID,
                    Par_Monto,              Par_Tasa,               Par_Frecu,                  Par_PagoCuota,                  Par_PagoFinAni,
                    Par_DiaMes,             Par_FechaInicio,        Par_NumeroCuotas,           Par_ProducCreditoID,            Par_ClienteID,
                    Par_DiaHabilSig,        Par_AjustaFecAmo,       Par_AjusFecExiVen,          Par_ComAper,                    Par_MontoGL,
                    Par_CobraSeguroCuota,   Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,       Par_ComAnualLin,                Par_Salida,
                    Par_NumErr,             Par_ErrMen,             Par_NumTran,                Par_Cuotas,                     Par_Cat,
                    Par_MontoCuo,           Par_FechaVen,           Par_EmpresaID,              Aud_Usuario,                    Aud_FechaActual,
                    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,               Aud_NumTransaccion);
            END IF;

		ELSE

            CALL CRESIMSALGLOPRO(
						Par_Monto,				Par_Tasa,				Par_Frecu,					Par_PagoCuota,					Par_PagoFinAni,
						Par_DiaMes,				Par_FechaInicio,		Par_NumeroCuotas,			Par_ProducCreditoID,			Par_ClienteID,
						Par_DiaHabilSig,		Par_AjustaFecAmo,		Par_AjusFecExiVen,			Par_ComAper,					Par_MontoGL,
						Par_CobraSeguroCuota,	Par_CobraIVASeguroCuota,Par_MontoSeguroCuota,		Par_ComAnualLin,				Par_Salida,
						Par_NumErr,				Par_ErrMen,				Par_NumTran,				Par_Cuotas,						Par_Cat,
						Par_MontoCuo,			Par_FechaVen,			Par_EmpresaID,				Aud_Usuario,					Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);
        END IF;


        IF(Par_NumErr!=0) THEN
			LEAVE ManejoErrores;
		ELSE
			SET Par_NumErr    := 0;
			SET Par_ErrMen    := 'Simulacion Exitosa';
        END IF;


     END ManejoErrores;

     IF(Par_Salida = Var_SI AND Par_NumErr != Entero_Cero)THEN
		SELECT
			0,                      Cadena_Vacia,       Cadena_Vacia,
			Cadena_Vacia,           Entero_Cero,        Entero_Cero,
			Entero_Cero,            Entero_Cero,        Entero_Cero,
			Entero_Cero,            Entero_Cero,        Aud_NumTransaccion,
			Entero_Cero,            Cadena_Vacia,       Cadena_Vacia,
			Entero_Cero,            Entero_Cero,        Entero_Cero,
			Entero_Cero,
			Cadena_Vacia AS CobraSeguroCuota,
			Entero_Cero AS MontoSeguroCuota,
			Entero_Cero AS IVASeguroCuota,
			Entero_Cero AS TotalSeguroCuota,
			Entero_Cero AS TotalIVASeguroCuota,
			Entero_Cero AS OtrasComisiones,
			Entero_Cero AS IVAOtrasComisiones,
			Entero_Cero AS TotalOtrasComisiones,
			Entero_Cero AS TotalIVAOtrasComisiones,
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
     END IF;

END TerminaStore$$