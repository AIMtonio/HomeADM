-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGRODETGRIDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGRODETGRIDPRO`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGRODETGRIDPRO`(
	-- Para generar la tabla Espejo de la Solicitud de Credito Consolidada
	-- Modulo: Solicitud de Credito --> Registro --> Alta Solicitud Credito Consolidada.
	Par_SolicitudCreditoID  BIGINT(20),		-- Solicitud de credito

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Parametro Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control 			CHAR(50);		-- Control de Salida
	DECLARE Var_FolioConsolidaID	BIGINT(20);		-- ID de Tabla CRECONSOLIDAAGROENC


	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);			-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);			-- Constante Entero Uno
	DECLARE Fecha_Vacia			DATE;				-- Constante echa vacia
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Salida_SI			CHAR(1);			-- Constante Salida SI

	DECLARE Salida_NO			CHAR(1);			-- Constante Salida NO
	DECLARE Con_SI				CHAR(1);			-- Constante SI
	DECLARE Con_NO				CHAR(1);			-- Constante NO
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Constante Decimal Cero

	-- Declaracion de Baja
	DECLARE BajaFolioGRID		INT(11);			-- Baja de todos los Registros del Folio en la Tabla Espejo

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Fecha_Vacia			:= '1900-01-01';
	SET Cadena_Vacia		:= '';
	SET Salida_SI			:= 'S';

	SET Salida_NO			:= 'N';
	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';
	SET Decimal_Cero		:= 0.0;
	SET BajaFolioGRID		:= 2;

	-- Asignacion de variables
	SET Var_Control			:= Cadena_Vacia;
	SET Var_FolioConsolidaID := Entero_Cero;
	SET Par_SolicitudCreditoID := IFNULL(Par_SolicitudCreditoID, Entero_Cero);
	SET Aud_NumTransaccion 	:= IFNULL(Aud_NumTransaccion, Entero_Cero);


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := '999';
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-CRECONSOLIDAAGRODETGRIDPRO');
			SET Var_Control := 'sqlException' ;
		END;

		IF( Par_SolicitudCreditoID <> Entero_Cero ) THEN

			SELECT FolioConsolida
			INTO Var_FolioConsolidaID
			FROM CRECONSOLIDAAGROENC
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			SET Var_FolioConsolidaID := IFNULL(Var_FolioConsolidaID, Entero_Cero);

			IF( Var_FolioConsolidaID <> Entero_Cero ) THEN

				IF( Aud_NumTransaccion = Entero_Cero ) THEN
					CALL TRANSACCIONESPRO(Aud_NumTransaccion);
				END IF;

				CALL CRECONSOLIDAAGROBAJ(
					Var_FolioConsolidaID,	Entero_Cero,		Entero_Cero,	Aud_NumTransaccion,		BajaFolioGRID,
					Con_NO,					Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,			Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,			Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				INSERT INTO CREDCONSOLIDAAGROGRID (
					DetGridID,			FolioConsolida,		SolicitudCreditoID,		CreditoID,			Transaccion,
					MontoCredito,		MontoProyeccion,
					EmpresaID,			Usuario,			FechaActual,			DireccionIP,		ProgramaID,
					Sucursal,			NumTransaccion)
				SELECT
					DetConsolidaID,		FolioConsolida, 	SolicitudCreditoID, 	CreditoID, 			Aud_NumTransaccion,
					MontoCredito,		MontoProyeccion,
					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion
				FROM CRECONSOLIDAAGRODET
				WHERE FolioConsolida = Var_FolioConsolidaID;

			END IF;
		END IF;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := CONCAT('La solicitud de Credito No. ', Par_SolicitudCreditoID, ', Ha creado su detalle de creditos consolidados de forma exitosa.');
		SET Var_Control := 'folioConsolidaID' ;
		LEAVE ManejoErrores;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen			 AS ErrMen,
				Var_Control			 AS control,
				Var_FolioConsolidaID AS consecutivo,
				Aud_NumTransaccion 	 AS consecutivoInt;
	END IF;

END TerminaStore$$