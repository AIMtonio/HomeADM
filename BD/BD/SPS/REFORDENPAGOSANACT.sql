DELIMITER ;
DROP PROCEDURE IF EXISTS `REFORDENPAGOSANACT`;

DELIMITER $$
CREATE PROCEDURE `REFORDENPAGOSANACT`(
	/*
	* SP para actualizar el estatus de la referencio o la referencia de la orden de pago
	*/
	Par_FolioOperacion 		INT(11), 		-- Identificador de la tabla DISPERSION
	Par_ClaveDispMov 		INT(11), 		-- Id de la tabla DISPERSIONMOV
	Par_Referencia 			VARCHAR(20), 	-- Referencia que se genera para la dispersion por orden de pago
	Par_NumActualiza		INT(11),		-- Numero de actualizacion


	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr 		INT(11),		-- numero de Error
	INOUT Par_ErrMen 		VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(50);	-- Variable de control
	DECLARE Var_RefOrdenID		INT(11);		-- Identificador de  la referencia de la orden de pago
	DECLARE Var_FechaRegistro 	DATE;			-- Fecha de registro de la referencia
	DECLARE Var_FechaVencimiento DATE;			-- Fecha de vencimiento de la referencia
	DECLARE Var_FechaCambio		DATE;			-- Fecha en que se realizara el cambio
	DECLARE Var_Tipo			INT(11);		-- Tipo de referencia generada 71 - Credito 81 - Otro 91.- Cuenta
	DECLARE Var_Folio			VARCHAR(12);	-- Folio puede ser el credito la cuenta o un numero aleatorio
	DECLARE Var_Referencia		VARCHAR(20);	-- Referencia generada previamente
	DECLARE Var_Complemento		VARCHAR(18);	-- Complemento en algunos casos el el valor aleatorio que se genero para la referencia
	DECLARE Var_FechaVen 		DATE;



	-- Delcaracion de Constantes
	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Fecha_Vacia			DATE;			-- Cconstante Fecha Vacia
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_Otro			INT(11);		-- Tipo de dispersion Otro
	DECLARE Con_Credito			INT(11);		-- Tipo de dispersion Credito
	DECLARE Con_Cuenta			INT(11);		-- Tipo de dispersion Cuenta

	DECLARE Act_Enviada			INT(11);		-- Actualizacion a Enviado
	DECLARE Act_Vencido			INT(11);		-- Actualizacion a Vencido
	DECLARE Act_Modificado		INT(11);		-- Actualizacion a Modificado
	DECLARE Act_Cancelado		INT(11);		-- Actualizacion a Cancelado
	DECLARE Act_Ejecutado		INT(11);		-- Actualizacion a Ejecutado
	DECLARE Act_Proceso			INT(11);		-- Actualizacion a En Proceso
	DECLARE Act_Programado		INT(11);		-- Actualizacion a Programado

	DECLARE Est_Enviado			CHAR(1);		-- Constante Estatus Enviado
	DECLARE Est_Vencido			CHAR(1);		-- Constante Estatus Vencido
	DECLARE Est_Modificado		CHAR(1);		-- Constante Estatus Modificado
	DECLARE Est_Cancelado		CHAR(1);		-- Constante Estatus Cancelado
	DECLARE Est_Ejecutado		CHAR(1);		-- Constante Estatus Ejecutado
	DECLARE Est_Proceso			CHAR(1);		-- Constante Estatus En Proceso
	DECLARE Est_Programado		CHAR(1);		-- Constante Estatus Programado

	-- Seteo de valores
	SET Salida_NO		:= 'N';
	SET Salida_SI		:= 'S';
	SET Entero_Cero		:= 0;
	SET Fecha_Vacia		:= '1900-01-01';
	SET Cadena_Vacia	:= '';
	SET Aud_FechaActual := NOW();
	SET Con_Otro		:= 81;
	SET Con_Credito		:= 71;
	SET Con_Cuenta		:= 91;

	SET Act_Enviada			:= 1;
	SET Act_Vencido			:= 2;
	SET Act_Modificado		:= 3;
	SET Act_Cancelado		:= 4;
	SET Act_Ejecutado		:= 5;
	SET Act_Proceso			:= 6;
	SET Act_Programado		:= 7;

	SET Est_Enviado			:= 'E';
	SET Est_Vencido			:= 'V';
	SET Est_Modificado		:= 'M';
	SET Est_Cancelado		:= 'C';
	SET Est_Ejecutado		:= 'O';
	SET Est_Proceso			:= 'P';
	SET Est_Programado		:= 'R';


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 	 'Disculpe las molestias que esto le ocasiona. Ref: SP-REFORDENPAGOSANACT');
				SET Var_Control := 'ordenPagoID';
			END;

		-- Obtenemos la inforacion de la referencia a modificar
		SELECT RefOrdenID, 		Referencia, 		Complemento,		FechaRegistro, 		FechaVencimiento,		Tipo,			Folio
		INTO   Var_RefOrdenID,	Var_Referencia,		Var_Complemento,	Var_FechaRegistro,	Var_FechaVencimiento,	Var_Tipo,		Var_Folio
		FROM REFORDENPAGOSAN
		WHERE FolioOperacion =Par_FolioOperacion   AND  ClaveDispMov = Par_ClaveDispMov;

		-- Obtenemos la fecha del sistema para la fecha de cambio de la actualizacion
		SELECT FechaSistema
		INTO Var_FechaCambio
		FROM PARAMETROSSIS;

		-- Validamos nulos
		SET Var_RefOrdenID 	:= IFNULL(Var_RefOrdenID,Entero_Cero);
		SET Var_Referencia 	:= IFNULL(Var_Referencia,Cadena_Vacia);
		SET Var_Complemento := IFNULL(Var_Complemento,Cadena_Vacia);
		SET Var_FechaRegistro := IFNULL(Var_FechaRegistro,Fecha_Vacia);
		SET Var_FechaVencimiento := IFNULL(Var_FechaVencimiento,Fecha_Vacia);
		SET Var_Tipo := IFNULL(Var_Tipo,Entero_Cero);
		SET Var_Folio := IFNULL(Var_Folio,Cadena_Vacia);

		SET Par_Referencia := IFNULL(Par_Referencia,Cadena_Vacia);

		SET Var_FechaCambio := IFNULL(Var_FechaCambio,Fecha_Vacia);


		-- Validamos que exista la referencia
		IF Var_RefOrdenID = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'No existe la referencia de orden de pago';
			LEAVE ManejoErrores;
		END IF;

		-- Validamos si se envia una referencia o se toma la existente
		IF Par_Referencia = Cadena_Vacia THEN
			SET Par_Referencia := Var_Referencia;
		END IF;

		-- 1 .- Actualizacion de estatus a ENVIADA
		IF Par_NumActualiza = Act_Enviada THEN

			UPDATE REFORDENPAGOSAN SET
				Estatus 		= Est_Enviado,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramso en la bitacora el estatus
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Enviado,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- 2 .- Actualizacion de estatus a VENCIDO
		IF Par_NumActualiza = Act_Vencido THEN

			UPDATE REFORDENPAGOSAN SET
				Estatus 		= Est_Vencido,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramso el estauts en la bitacora
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Vencido,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- 3 .- Actualizacion de estatus a MODIFICADO
		IF Par_NumActualiza = Act_Modificado THEN
			IF (Var_Tipo = Con_Otro) THEN
				SET Var_Complemento := SUBSTRING(Par_Referencia,3,20);
			END IF;
			IF(Var_Tipo = Con_Cuenta)THEN
				SET Var_Complemento := SUBSTRING(Par_Referencia,15,20);
			END IF;
			IF(Var_Tipo = Con_Credito)THEN
				SET Var_Complemento := SUBSTRING(Par_Referencia,14,19);
			END IF;

			UPDATE REFORDENPAGOSAN SET
				Referencia 		= Par_Referencia,
				Complemento 	= Var_Complemento,

				Estatus 		= Est_Modificado,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramos en la bitacora el estatus
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Modificado,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;


		-- 4 .- Actualizacion de estatus a CANCELADO
		IF Par_NumActualiza = Act_Cancelado THEN
			UPDATE REFORDENPAGOSAN SET
				Estatus 		= Est_Cancelado,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramos el estatus en la bitacora
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Cancelado,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- 5 .- Actualizacion de estatus a EJECUTADO
		IF Par_NumActualiza = Act_Ejecutado THEN

			UPDATE REFORDENPAGOSAN SET
				Estatus 		= Est_Ejecutado,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramos el estatus en la bitacora
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Ejecutado,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- -- 6 .- Actualizacion de estatus a EN PROCESO
		IF Par_NumActualiza = Act_Proceso THEN

			UPDATE REFORDENPAGOSAN SET
				Estatus 		= Est_Proceso,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramos el estatus en la bitacora
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Proceso,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- -- 7 .- Actualizacion de estatus a PROGRAMADO
		IF Par_NumActualiza = Act_Programado THEN

			UPDATE REFORDENPAGOSAN SET
				Estatus 		= Est_Programado,
				EmpresaID		= Par_EmpresaID,
				Usuario         = Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE 	FolioOperacion 	=	Par_FolioOperacion
			AND  	ClaveDispMov 	= 	Par_ClaveDispMov;

			-- Registramos el estatus en la bitacora
			CALL BITREFORDENPAGOSANALT(
								Var_RefOrdenID,			Par_Referencia,			Var_Complemento,		Par_FolioOperacion,		Par_ClaveDispMov,
								Var_FechaRegistro,		Var_FechaVencimiento,	Var_FechaCambio,		Var_Tipo,				Var_Folio,
								Est_Programado,
								Salida_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen 		:= CONCAT('Referencia de orden de pago actualizado exitosamente: ',CONVERT(Var_RefOrdenID,CHAR(10)));
		SET Var_Control		:= 'folioOperacion';


	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_RefOrdenID	AS consecutivo;
	END IF;


END TerminaStore$$