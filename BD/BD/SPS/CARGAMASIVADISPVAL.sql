DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAMASIVADISPVAL`;
DELIMITER $$
CREATE PROCEDURE `CARGAMASIVADISPVAL`(
	Par_InstitucionID 		INT(11),			-- Numero de la institucion Bancaria
	Par_NumCtaInstit 		VARCHAR(20),		-- Cuenta de la institucion Bancaria
	Par_FechaDispersion		DATE,				-- Fecha para la dispersion
	Par_RutaArchivo			VARCHAR(300),		-- Ruta del archivo que se carga

	Par_Salida            	CHAR(1),      		-- Indica si requiere salida
	INOUT Par_NumErr      	INT(11),        	-- Numero de error
	INOUT Par_ErrMen      	VARCHAR(400),   	-- Mensaje de error

  /* Parametros de Auditoria */
  	Par_EmpresaID           INT(11),        	
	Aud_Usuario             INT(11),
	Aud_FechaActual         DATETIME,

	Aud_DireccionIP         VARCHAR(15),
	Aud_ProgramaID          VARCHAR(50),
	Aud_Sucursal            INT(11),
	Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN
	
	-- Declaracion de variables
	DECLARE Var_Control       	VARCHAR(20);	-- Constante para la variable de control
	DECLARE Var_TipoCuenta 		INT(11); 		-- Tipo de cuenta 1= Cuenta contable	2= Cuenta de Ahorro 3= Crédito
	DECLARE Var_CuentaCargo 	VARCHAR(50); 	-- Cuenta de ahorro o cuenta contable
	DECLARE Var_Descripcion 	VARCHAR(50); 	-- Descripción del movimiento
	DECLARE Var_Referencia 		VARCHAR(50); 	-- Referencia del movimiento
	DECLARE Var_FormaPago 		CHAR(1); 		-- Forma de Pago S=SPEI C=Cheque O=Orden de Pago A=Transferencia Santander
	DECLARE Var_CtaBenefi	 	VARCHAR(50); 	-- Cuenta a la que se realizará el pago.
	DECLARE Var_Monto 			DECIMAL(14,2); 	-- Monto a dispersar
	DECLARE Var_NombreBenefi 	VARCHAR(150); 	-- Nombre del Beneficiario
	DECLARE Var_RFC 			VARCHAR(13); 	-- RFC del beneficiario
	DECLARE Var_Contador		INT(11);		-- Contador para el ciclo WHILE
	DECLARE Var_Longitud		INT(11);		-- Longitud para ser recorridos

	DECLARE Var_Institucion		INT(11);		-- Variable para validar institucion
	DECLARE Var_CtaInstitu		VARCHAR(20);	-- Variable para validar la cuenta de la institucion
	DECLARE Var_DispMasivaID	INT(11);		-- Folio de alta de encabezado
	DECLARE Var_SaldoDispon		DECIMAL(12,2);
	DECLARE Var_CuentaContable	VARCHAR(20);
	DECLARE Var_CuentaAhoTeso	INT(11);
	DECLARE Var_SaldoCta		DECIMAL(14,2);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_CteRFC			VARCHAR(13);
	DECLARE Var_Chequera		CHAR(1);

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Est_Validacion		CHAR(1);		-- Estatus Validacion
	DECLARE Salida_SI			CHAR(1);		-- Salida SI
	DECLARE Salida_NO			CHAR(1);		-- Salida NO
	DECLARE Cta_Detalle			CHAR(1);		-- Cuenta de Detalle
	DECLARE Cta_Cabecera		CHAR(1);		-- Cuenta de Cabecera
	DECLARE Con_Contable		INT(11);		-- Tipo de cuenta 
	DECLARE Con_Ahorro			INT(11);		-- Tipo de cuenta 
	DECLARE Con_Credito			INT(11);		-- Tipo de cuenta 
	DECLARE Con_SPEI			CHAR(1);		-- Forma de Pago
	DECLARE Con_Cheque			CHAR(1);		-- Forma de Pago
	DECLARE Con_Orden			CHAR(1);		-- Forma de Pago
	DECLARE Con_Transfer		CHAR(1);		-- Forma de Pago


	DECLARE Cat_SaldoInsuf		INT(11);
	DECLARE Cat_CtaNoExist		INT(11);
	DECLARE Cat_CtaConNoExist	INT(11);
	DECLARE Cat_CtaConMayor		INT(11);
	DECLARE Cat_TipoCtaInc		INT(11);
	DECLARE Cat_TipoDispInc		INT(11);
	DECLARE Cat_MontoMayor		INT(11);
	DECLARE Cat_RFCNoCorres		INT(11);
	DECLARE Cat_NoChequera		INT(11);
	
	-- Seteo de valores
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Est_Validacion			:= 'V';
	SET Aud_FechaActual 		:= NOW();
	SET Salida_SI				:= 'S';
	SET Salida_NO				:= 'N';
	SET Cta_Cabecera			:= 'E';
	SET Cta_Detalle				:= 'D';
	SET Con_Contable			:= 1;		
	SET Con_Ahorro				:= 2;		
	SET Con_Credito				:= 3;	
	SET Con_SPEI				:= 'S';
	SET Con_Cheque				:= 'C';	
	SET Con_Orden				:= 'O';		
	SET Con_Transfer			:= 'A';	

	SET Cat_SaldoInsuf		:= 1;
	SET Cat_CtaNoExist		:= 2;
	SET Cat_CtaConNoExist	:= 3;
	SET Cat_CtaConMayor		:= 4;
	SET Cat_TipoCtaInc		:= 5;
	SET Cat_TipoDispInc		:= 6;
	SET Cat_MontoMayor		:= 7;
	SET Cat_RFCNoCorres		:= 8;
	SET Cat_NoChequera		:= 9;

	ManejoErrores:BEGIN

			DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr   := 999;
				SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					'esto le ocasiona. Ref: SP-CARGAMASIVADISPVAL');
				SET Var_Control  := 'SQLEXCEPTION';
			END;

	
		SET Var_Institucion := IFNULL((SELECT InstitucionID
									FROM INSTITUCIONES 
									WHERE InstitucionID= Par_InstitucionID ),Entero_Cero);


		IF(IFNULL(Var_Institucion,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'La Institucion especificada no Existe';
			SET Var_Control := 'institucionID';
			LEAVE ManejoErrores;
		END IF;



		SELECT 	teso.NumCtaInstit,	teso.CuentaAhoID, teso.chequera 
		INTO 	Var_CtaInstitu, 	Var_CuentaAhoTeso, Var_Chequera
		FROM CUENTASAHOTESO teso 
		INNER JOIN CUENTASAHO aho ON teso.CuentaAhoID = aho.CuentaAhoID 
		WHERE teso.InstitucionID= Par_InstitucionID 
		AND teso.NumCtaInstit= Par_NumCtaInstit;


		IF(IFNULL(Var_CtaInstitu,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'La Cuenta Bancaria especificada no Existe';
			SET Var_Control := 'numCtaInstit'; 
			LEAVE ManejoErrores;
		END IF;

		SET Var_Contador := Entero_Uno;

		CALL CARGAMASIVADISPALT(Par_FechaDispersion,	Par_InstitucionID,	Par_NumCtaInstit,	Entero_Cero,		Par_RutaArchivo,
								Est_Validacion,			Salida_NO, 			Par_NumErr,			Par_ErrMen,			Var_DispMasivaID,
								Par_EmpresaID,     		Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
								Aud_Sucursal,  			Aud_NumTransaccion);

		IF Par_NumErr != Entero_Cero THEN
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(MAX(Consecutivo),Entero_Cero) INTO Var_Longitud FROM TMPCARGAMASIVADISP
		WHERE NumTransaccion = Aud_NumTransaccion;

		IF IFNULL(Var_Longitud,Entero_Cero) = Entero_Cero THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El archivo no tine registros para validar';
			SET Var_Control := 'numCtaInstit'; 
			LEAVE ManejoErrores;
		END IF;


		WHILE (Var_Contador <= Var_Longitud) DO
			
			SELECT 	TipoCuenta,		CONVERT(ROUND(CuentaCargo),CHAR),	Descripcion,	Referencia, FormaPago,
					CONVERT(ROUND(CtaBenefi),CHAR),		Monto,			NombreBenefi,	RFC
			INTO 	Var_TipoCuenta,		Var_CuentaCargo,	Var_Descripcion,	Var_Referencia, Var_FormaPago,
					Var_CtaBenefi,		Var_Monto,			Var_NombreBenefi,	Var_RFC
			FROM  TMPCARGAMASIVADISP
			WHERE Consecutivo = Var_Contador AND NumTransaccion = Aud_NumTransaccion;

			IF IFNULL(Var_TipoCuenta,Entero_Cero) = Con_Ahorro THEN


				SELECT 	SaldoDispon,		CuentaAhoID 
				INTO 	Var_SaldoDispon,	Var_CuentaAhoID 
				FROM CUENTASAHO 
				WHERE CuentaAhoID = Var_CuentaCargo;

				-- 1.- Saldo insuficiente
				IF IFNULL(Var_SaldoDispon,Entero_Cero) < IFNULL(Var_Monto,Entero_Cero) THEN

					CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_SaldoInsuf,		Salida_NO, 			Par_NumErr,
												Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

				-- 2.- La cuenta de ahorro no existe
				IF IFNULL(Var_CuentaAhoID,Entero_Cero) = Entero_Cero THEN
					
					CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_CtaNoExist,		Salida_NO, 			Par_NumErr,
												Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

			END IF;


			IF IFNULL(Var_TipoCuenta,Entero_Cero) = Con_Contable THEN
				
				SELECT CuentaCompleta INTO Var_CuentaContable 
				FROM CUENTASCONTABLES
				WHERE CuentaCompleta = Var_CuentaCargo;

				-- 3.- La cuenta contable no existe
				IF IFNULL(Var_CuentaContable, Cadena_Vacia) = Cadena_Vacia THEN
					CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),	Cat_CtaConNoExist,	Salida_NO, 			Par_NumErr,
											Par_ErrMen,				Par_EmpresaID,  Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,			Aud_Sucursal,  	Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
				
				SET Var_CuentaContable := Cadena_Vacia;

				SELECT CuentaCompleta INTO Var_CuentaContable 
				FROM CUENTASCONTABLES
				WHERE CuentaCompleta = Var_CuentaCargo AND Grupo = Cta_Cabecera;

				-- 4.- La cuenta contable es una cuenta de Mayor y no de Detalle.
				IF IFNULL(Var_CuentaContable, Cadena_Vacia) != Cadena_Vacia THEN

					CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),	Cat_CtaConMayor,	Salida_NO, 			Par_NumErr,
											Par_ErrMen,				Par_EmpresaID,  Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,			Aud_Sucursal,  	Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

			END IF;

			-- 5.- El tipo de cuenta es incorrecto
			IF IFNULL(Var_TipoCuenta,Entero_Cero) != Con_Contable AND IFNULL(Var_TipoCuenta,Entero_Cero) != Con_Ahorro AND IFNULL(Var_TipoCuenta,Entero_Cero) != Con_Credito THEN
				CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_TipoCtaInc,		Salida_NO, 			Par_NumErr,
											Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
			END IF;

			-- 6.- El tipo de dispersión es incorrecto
			IF IFNULL(Var_FormaPago,Cadena_Vacia) != Con_SPEI AND IFNULL(Var_FormaPago,Cadena_Vacia) != Con_Cheque AND IFNULL(Var_FormaPago,Cadena_Vacia) != Con_Orden AND IFNULL(Var_FormaPago,Cadena_Vacia) != Con_Transfer THEN
				CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_TipoDispInc,	Salida_NO, 			Par_NumErr,
											Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
			END IF;

			-- 7.- El monto debe se mayor a cero
			IF IFNULL(Var_Monto,Entero_Cero) <= Entero_Cero THEN
				CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_MontoMayor,		Salida_NO, 			Par_NumErr,
											Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
											Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
			END IF;

			-- 8.- El RFC no corresponde al capturado para el cliente.
			IF IFNULL(Var_TipoCuenta,Entero_Cero) = Con_Ahorro THEN
				SELECT RFCOficial INTO Var_CteRFC 
				FROM CLIENTES C
				INNER JOIN CUENTASAHO A ON C.ClienteID = A.ClienteID
				WHERE A.CuentaAhoID =  Var_CuentaCargo;

				IF IFNULL(TRIM(Var_CteRFC),Cadena_Vacia) != IFNULL(TRIM(Var_RFC),Cadena_Vacia) THEN
					CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_RFCNoCorres,	Salida_NO, 			Par_NumErr,
												Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;

			IF IFNULL(Var_FormaPago,Cadena_Vacia) = Con_Cheque THEN
				IF IFNULL(Var_Chequera,Cadena_Vacia) = Salida_NO THEN
					CALL VALCARGAMASIVADISPALT(Var_DispMasivaID,	(Var_Contador+1),		Cat_NoChequera,	Salida_NO, 			Par_NumErr,
												Par_ErrMen,			Par_EmpresaID,     	Aud_Usuario,   		Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,  		Aud_NumTransaccion);

					IF Par_NumErr != Entero_Cero THEN
						LEAVE ManejoErrores;
					END IF; 
				END IF;
			END IF;

			SET Var_Contador := Var_Contador +Entero_Uno;

		END WHILE;


		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('Validacion Realizada Exitosamente.');
		SET Var_Control := 'institucionID';
			
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Aud_NumTransaccion AS Consecutivo;
	END IF;
END TerminaStore$$