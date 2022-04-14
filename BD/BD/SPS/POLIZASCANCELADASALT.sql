-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZASCANCELADASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZASCANCELADASALT`;DELIMITER $$

CREATE PROCEDURE `POLIZASCANCELADASALT`(
	/*SP para dar de alta las polizas canceladas*/
	Par_PolizaID				BIGINT(20),				# Numero de Poliza
	Par_Transaccion				BIGINT(20),				# Numero de transaccion
	Par_DescProceso				VARCHAR(400),			# Descripcion del proceso
	Par_NumErrPol				INT(11),				# Numero de error que provoco que se cancelara
	Par_ErrMenPol				VARCHAR(400),			# Mensaje de error que provoco que se cancelara
	Par_Salida					CHAR(1),				# Salida S:Si N:No

INOUT Par_NumErr				INT(11),				# Numero de error
INOUT Par_ErrMen				VARCHAR(400),			# Mensaje de error
	Aud_EmpresaID				INT(11),				# Auditoria
	Aud_Usuario					INT(11),				# Auditoria
	Aud_FechaActual				DATETIME,				# Auditoria

	Aud_DireccionIP				VARCHAR(15),			# Auditoria
	Aud_ProgramaID				VARCHAR(50),			# Auditoria
	Aud_Sucursal				INT(11),				# Auditoria
	Aud_NumTransaccion			BIGINT(20)				# Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE SalidaSI				CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(20);	-- Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	-- Valor del consecutivo
    DECLARE Var_ConsecutivoID		BIGINT(20);		-- Consecutivo ID

	-- Asignacion de Constantes
	SET SalidaSI			:= 'S';				-- Salida SI
	SET Entero_Cero			:= 0;				-- entero Cero
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZASCANCELADASALT');
			SET Var_Control := 'sqlException';
		END;

		IF(Par_PolizaID>Entero_Cero) THEN

			SET Var_ConsecutivoID := (SELECT IFNULL(MAX(Consecutivo),0)+1 FROM POLIZASCANCELADAS);

			INSERT INTO POLIZASCANCELADAS
			(Consecutivo,		PolizaID,		EmpresaID,		Fecha,					Tipo,
            ConceptoID,			Concepto,		NumErr,			ErrMen,					DescProceso,
            Usuario,			FechaActual,	DireccionIP,	ProgramaID,				Sucursal,
            NumTransaccion)
			SELECT
				Var_ConsecutivoID,	PolizaID,		EmpresaID,		Fecha,				Tipo,
                ConceptoID,			Concepto,		Par_NumErrPol,	Par_ErrMenPol,		Par_DescProceso,
                Usuario,			FechaActual,		DireccionIP,	ProgramaID,		Sucursal,
                NumTransaccion
				FROM POLIZACONTABLE
					WHERE PolizaID = Par_PolizaID;
			SET Var_Control := 'polizaID';
			SET Var_Consecutivo := Par_PolizaID;
		ELSE
			INSERT INTO POLIZASCANCELADAS
			(PolizaID,			EmpresaID,		Fecha,			Tipo,					ConceptoID,
			Concepto,			NumErr,			ErrMen,			DescProceso,			Usuario,
			FechaActual,		DireccionIP,	ProgramaID,		Sucursal,				NumTransaccion)
			SELECT
				PolizaID,		EmpresaID,		Fecha,			Tipo,					ConceptoID,
				Concepto,		Par_NumErrPol,	Par_ErrMenPol,	Par_DescProceso,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,				NumTransaccion
				FROM POLIZACONTABLE
					WHERE PolizaID = Par_PolizaID;
			SET Var_Control := 'transaccionID';
			SET Var_Consecutivo := Par_Transaccion;
		END IF;

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('La Poliza Contable ',Par_PolizaID,' Respaldada Exitosamente.');
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$