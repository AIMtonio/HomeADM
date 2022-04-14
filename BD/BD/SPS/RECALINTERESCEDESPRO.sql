-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RECALINTERESCEDESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RECALINTERESCEDESPRO`;DELIMITER $$

CREATE PROCEDURE `RECALINTERESCEDESPRO`(
# =============================================================
# -----SP PARA REALIZAR EL RECALCULO DE INTERESES EN CEDES-----
# =============================================================
    Par_CedeID          BIGINT(11),     -- ID de la Cede

    Par_Salida          CHAR(1),        -- Salida en Pantalla
    INOUT   Par_NumErr  INT(11),        -- Salida en Pantalla Numero de Error o Exito
    INOUT   Par_ErrMen  VARCHAR(400),   -- Salida en Pantalla Numero de Error o Exito

    Par_EmpresaID       INT(11),        -- Auditoria
    Aud_Usuario         INT(11),        -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT(11),        -- Auditoria
    Aud_NumTransaccion  BIGINT(20)      -- Auditoria
)
TerminaStored: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero     	INT(1);
	DECLARE SalidaSi        	CHAR(1);
	DECLARE Esta_Vigente    	CHAR(1);
	DECLARE Esta_Pagado     	CHAR(1);

	-- Declaracion de Variables
	DECLARE Var_FechaSistema    DATE;
	DECLARE Var_DiasCredito     INT(11);
	DECLARE Var_SaldoCapita     DECIMAL(16,2);
	DECLARE Var_Interes         DECIMAL(14,4);
	DECLARE Var_Dias            INT(11);
	DECLARE Var_CedeID          BIGINT;
	DECLARE Var_AmortizacionID  INT(11);
	DECLARE Var_AmoCapital      DECIMAL(14,2);
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_FechaInicio     DATE;
	DECLARE Var_FechaVencim     DATE;
	DECLARE Var_FechaPago       DATE;
	DECLARE Var_AmoEstatus      CHAR(1);
	DECLARE Var_SaldoProvision  DECIMAL(16,2);
	DECLARE Var_CreTasa         DECIMAL(12,4);
	DECLARE Var_Control         VARCHAR(200);

	DECLARE CURSORAJUSTACEDE CURSOR FOR
		SELECT  Amo.CedeID,             Amo.AmortizacionID, Amo.Capital,    Ced.MonedaID,       Amo.FechaInicio,
				Amo.FechaVencimiento,   Amo.FechaPago,      Amo.Estatus,    Amo.SaldoProvision, Ced.TasaFija
			FROM 	AMORTIZACEDES Amo,
					CEDES Ced
			WHERE 	Amo.CedeID		= Ced.CedeID
			AND 	Ced.CedeID   	= Par_CedeID
			AND 	Ced.Estatus   	= Esta_Vigente
			AND 	Amo.Estatus   	= Esta_Vigente
			AND 	Amo.FechaPago	> Var_FechaSistema
			ORDER BY Amo.FechaPago ;

	-- Asignacion de Constantes
	SET Entero_Cero         :=  0;          -- Entero en Cero
	SET SalidaSi            := 'S';         -- Salida SI
	SET Esta_Vigente        := 'N';         -- Estatus del Cede Vigente
	SET Esta_Pagado         := 'P';         -- Estatus del Cede Pagado

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-RECALINTERESCEDESPRO');
				SET Var_Control ='SQLEXCEPTION';
			END;

		SELECT FechaSistema, DiasCredito INTO Var_FechaSistema, Var_DiasCredito
			FROM PARAMETROSSIS;

		SELECT  SUM(IFNULL(Amo.Capital, Entero_Cero)) INTO Var_SaldoCapita
			FROM 	AMORTIZACEDES Amo
			WHERE 	Amo.CedeID 	=  Par_CedeID
			AND 	Amo.Estatus <> Esta_Pagado;

		SET Var_SaldoCapita := IFNULL(Var_SaldoCapita, Entero_Cero);

		IF(Var_SaldoCapita > Entero_Cero) THEN

			OPEN CURSORAJUSTACEDE;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLOAMORTICEDE:LOOP

					FETCH CURSORAJUSTACEDE INTO
						Var_CedeID,         Var_AmortizacionID, Var_AmoCapital,     Var_MonedaID,       Var_FechaInicio,
						Var_FechaVencim,    Var_FechaPago,      Var_AmoEstatus,     Var_SaldoProvision, Var_CreTasa;


						SET Var_SaldoProvision 	:= IFNULL(Var_SaldoProvision, Entero_Cero);
						SET Var_AmoCapital 		:= IFNULL(Var_AmoCapital, Entero_Cero);
						SET Var_Interes 		:= Entero_Cero;
						SET Var_CreTasa 		:= IFNULL(Var_CreTasa, Entero_Cero);

						IF(Var_FechaInicio < Var_FechaSistema) THEN
							SET Var_Dias = DATEDIFF(Var_FechaVencim, Var_FechaSistema);
						ELSE
							SET Var_Dias = DATEDIFF(Var_FechaVencim, Var_FechaInicio);
						END IF;

						SET Var_Interes := Var_SaldoCapita * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00);

						UPDATE AMORTIZACEDES SET
									Interes 		= ROUND(Var_Interes + Var_SaldoProvision, 2),
									Total 			= ROUND(Capital + IFNULL(Interes, 0) - IFNULL(InteresRetener,Entero_Cero), 2)
							WHERE   CedeID   		= Var_CedeID
							AND   	AmortizacionID  = Var_AmortizacionID;

						SET Var_SaldoCapita := Var_SaldoCapita - Var_AmoCapital;

					END LOOP CICLOAMORTICEDE;
				END;
			CLOSE CURSORAJUSTACEDE;
		END IF;

		UPDATE CEDES Ced SET
			Ced.InteresGenerado = (SELECT SUM(Amo.Interes)
									FROM 	AMORTIZACEDES Amo
									WHERE 	Amo.CedeID = Par_CedeID )
			WHERE Ced.CedeID = Par_CedeID;

		UPDATE CEDES Ced SET
					Ced.InteresRecibir 	= Ced.InteresGenerado - Ced.InteresRetener
			WHERE 	Ced.CedeID 			= Par_CedeID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Recalculo de Intereses Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				'cedeID' 	AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStored$$