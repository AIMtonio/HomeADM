DELIMITER ;
DROP PROCEDURE IF EXISTS BITREFORDENPAGOSANALT;

DELIMITER $$
CREATE PROCEDURE BITREFORDENPAGOSANALT(

	Par_RefOrdenID 			INT(11),		--
  	Par_Referencia 			VARCHAR(20), 	-- Referencia que se genera para la dispersion por orden de pago
  	Par_Complemento 		VARCHAR(18), 		-- Los  6 digito aleatorios de la referecia
  	Par_FolioOperacion 		INT(11), 		-- Identificador de la tabla DISPERSION
  	Par_ClaveDispMov 		INT(11), 		-- Id de la tabla DISPERSIONMOV
  	Par_FechaRegistro 		DATE, 			-- Fecha en que se realizo el registro
  	Par_FechaVencimiento 	DATE, 			-- Fecha de vencimiento de la referencia
  	Par_FechaCambio			DATE,			-- Fecha en que se realiza el cambio
  	Par_Tipo 				INT(11), 		-- Tipo de referencia creada 71.-Credito 81.- Solicitud de Dispersion 91.- Cuentas
  	Par_Folio 				VARCHAR(12), 	-- Folio que se utiliza para generar la referencia creditoID,CuentaID, Folio de dispersion
  	Par_Estatus 			CHAR(1), 		-- Estatus de la referencia:\nGenerada(G): Enviada(E): Vencido(V): Modificado(M): Cancelado(C): Ejecutado(O): En proceso(P):  Programado(R):

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

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_Consecutivo INT(11);
	DECLARE Var_RefOrdenID	INT(11);

	-- Declaracion de Constantes
	DECLARE Entero_Cero		INT(11);
	DECLARE Salida_SI		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Fecha_Vacia		DATE;
	DECLARE Est_Generada	CHAR(1);

	-- Seteo de valores

	SET Entero_Cero			:= 0;
	SET Salida_SI			:= 'S';
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Aud_FechaActual		:= NOW();
	SET Est_Generada		:= 'G';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 	 'Disculpe las molestias que esto le ocasiona. Ref: SP-BITREFORDENPAGOSANALT');
				SET Var_Control := 'ordenPagoID';
			END;

		IF IFNULL(Par_RefOrdenID,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El identificador de la orden esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Referencia,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La referencia esta vacia';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Complemento,-1)< Entero_Cero THEN
			SET Par_NumErr := 3;
			SET Par_ErrMen := 'El complemento esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FolioOperacion,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 4;
			SET Par_ErrMen := 'El folio de operacion esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ClaveDispMov,Entero_Cero)= Entero_Cero THEN
			SET Par_NumErr := 5;
			SET Par_ErrMen := 'La clave de dispersion esta vacia';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FechaRegistro,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr := 6;
			SET Par_ErrMen := 'La fecha de registro esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FechaVencimiento,Fecha_Vacia) = Fecha_Vacia THEN
			SET Par_NumErr := 7;
			SET Par_ErrMen := 'La fecha de vencimiento esta vacia';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Tipo,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 8;
			SET Par_ErrMen := 'El tipo de referencia esta vacio';
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Folio,Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr := 9;
			SET Par_ErrMen := 'El folio de la dispersion esta vacio';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(ConsecutivoID),Entero_Cero)+1 INTO Var_Consecutivo
		FROM BITREFORDENPAGOSAN;

		INSERT INTO BITREFORDENPAGOSAN
		(ConsecutivoID,	RefOrdenID, 		Referencia, 		Complemento, 		FolioOperacion,
		ClaveDispMov,	FechaRegistro, 		FechaVencimiento, 	FechaCambio,		Tipo,
		Folio, 			Estatus,
		EmpresaID, 		Usuario, 			FechaActual, 	DireccionIP, 		ProgramaID,
		Sucursal, 		NumTransaccion)
		VALUES
		(Var_Consecutivo,	Par_RefOrdenID, 		Par_Referencia,			Par_Complemento, 		Par_FolioOperacion,
		 Par_ClaveDispMov,	Par_FechaRegistro, 		Par_FechaVencimiento, 	Par_FechaCambio,		Par_Tipo,
		 Par_Folio, 		Par_Estatus,
		 Par_EmpresaID,		Aud_Usuario,	 		Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
		 Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen 		:= CONCAT('Referencia de orde de pago agregado exitosamente: ',CONVERT(Var_Consecutivo,CHAR(10)));
		SET Var_Control		:= 'folioOperacion';


	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;
END TerminaStore$$