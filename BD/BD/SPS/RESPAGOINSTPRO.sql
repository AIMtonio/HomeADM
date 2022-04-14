-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGOINSTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPAGOINSTPRO`;
DELIMITER $$

CREATE PROCEDURE `RESPAGOINSTPRO`(
	-- ========================================================================================================
	-- ------------------------ SP PARA RESPALDO DESCNOMINAREAL DE PAGOS INSTITUCIONES (NOMINA)-----------------------------
	-- ========================================================================================================
	Par_FolioProceso		INT(11),			-- Folio de Carga en la que se proceso el Registro
	Par_FolioNominaID		INT(11),			-- Folio del Registro de Nomina
	Par_CreditoID			BIGINT(12),			-- ID del credito
	Par_MontoPago			DECIMAL(18,2),		-- Monto del pago
	Par_MovConciliado		BIGINT(20),			-- Movimiento de Conciliacion

	Par_Salida				CHAR(1),			-- Indica si espera select de salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT,				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT				-- Parametro de auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
    DECLARE Var_Control     VARCHAR(100);		-- Variable de control
   	DECLARE SalidaSI        CHAR(1);			-- Constante salida SI
	DECLARE Var_NumReg		INT(11);			-- Numero de Registros
	DECLARE Var_FolioNominaID	INT(11);		-- Variable Folio de Nomnina
	DECLARE Var_Origen		CHAR(1);			-- Variable de Origen del Folio I-Registro Importado F.- Registro Folio
	DECLARE Var_DetalleID	INT(11);			-- Detalle ID

    -- Declaracion de Constantes
    DECLARE Entero_Cero     INT(11);			-- Constante entero cero
	DECLARE Entero_Uno	    INT(11);			-- Constante entero cero
	DECLARE Con_Importado	CHAR(1);			-- Constante Origen Importado I
	DECLARE Con_Folio		CHAR(1);			-- Constante Origen Folio F

    -- Seteo de Constantes
    SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
    SET SalidaSI			:='S';
	SET Con_Importado		:='I';
	SET Con_Folio			:= 'F';

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-RESPAGOINSTPRO');
							SET Var_Control := 'SQLEXCEPTION' ;
				END;

		-- Si No existe registro de Detalle
		SET Var_DetalleID := (SELECT IFNULL(MAX(DetalleID),Entero_Cero)
								FROM DETALLEPAGNOMINST) + Entero_Uno;


		-- Se inserta en la tabla Detalle de Pago por Inst
		INSERT INTO DETALLEPAGNOMINST(
			DetalleID,		FolioCargaID,		NumRegistros,		NumPagosAplicados,		NumPagosImportados,
			MontoTotal,		MovConciliado,		EmpresaID,			Usuario,				FechaActual,
			DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
		SELECT
			Var_DetalleID,FolioProcesoID, COUNT(CreditoID),
			SUM(CASE
			 	WHEN FolioCargaID = Par_FolioProceso THEN Entero_Uno
				WHEN FolioCargaID != Par_FolioProceso THEN Entero_Cero
				ELSE Entero_Cero END) AS NumPagosAplicados,
			SUM(CASE
			 	WHEN FolioCargaID != Par_FolioProceso THEN Entero_Uno
				WHEN FolioCargaID  = Par_FolioProceso THEN Entero_Cero
				ELSE Entero_Cero END) AS NumPagosImportados,
			SUM(MontoPago),     Par_MovConciliado, Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM DESCNOMINAREAL
			WHERE FolioProcesoID = Par_FolioProceso
			GROUP BY FolioProcesoID;


		-- Se inserta a la tabla de Respaldo
		INSERT INTO RESPAMORTCRENOMINAREAL(
			TranRespaldo,		FolioNominaID,			FolioProceso,			CreditoID,				AmortizacionID,			FechaVencimiento,
			FechaExigible,		FechaPagoIns,			Estatus,				EstatusPagoBan,			EmpresaID,
			Usuario,			FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
			NumTransaccion)
		SELECT
			Aud_NumTransaccion,	amo.FolioNominaID,			Par_FolioProceso,		amo.CreditoID,				amo.AmortizacionID,			amo.FechaVencimiento,
			amo.FechaExigible,		amo.FechaPagoIns,		amo.Estatus,			amo.EstatusPagoBan,			amo.EmpresaID,
			amo.Usuario,			amo.FechaActual,		amo.DireccionIP,		amo.ProgramaID,				amo.Sucursal,
			amo.NumTransaccion
		FROM AMORTCRENOMINAREAL amo,DESCNOMINAREAL des
			WHERE des.FolioProcesoID = Par_FolioProceso
			AND amo.CreditoID = des.CreditoID;


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Respaldo Realizado con Exito.';

	END ManejoErrores; -- fin del manejador de errores

		IF (Par_Salida = SalidaSI) THEN
			SELECT Par_NumErr AS NumErr,
				   Par_ErrMen AS ErrMen,
				   'institNominaID' AS control;
		END IF;

END TerminaStore$$