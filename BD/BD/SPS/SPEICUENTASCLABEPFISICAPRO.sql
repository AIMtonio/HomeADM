-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEICUENTASCLABEPFISICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEICUENTASCLABEPFISICAPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEICUENTASCLABEPFISICAPRO`(
    Par_ClienteID 			INT(11),				-- ID del Cliente
    Par_CuentaClabe  		VARCHAR(18),			-- Cuenta Clabe a registrar ante STP
    Par_TipoInstrumento 	CHAR(2),				-- Tipo de Instrumento (CH = Cuenta de Ahorro, CR = Credito)
    Par_Instrumento			BIGINT(12),				-- ID del Instrumento dependiendo de Par_TipoInstrumento
    Par_Firma				VARCHAR(1000),			-- Firma para registro de cuenta clabe
    Par_NumPro				INT(11),				-- Numero de Proceso

	Par_Salida          	CHAR(1),				-- Identificador de SAlida
	INOUT Par_NumErr 		INT(11),				-- Numero de Error
	INOUT Par_ErrMen  		VARCHAR(400),			-- Mensaje de Error

	Aud_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT					-- Parametro de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    					CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia     					DATE;					-- Fecha vacia
	DECLARE Entero_Cero     					INT(11);				-- Entero cero
	DECLARE Con_NO       						CHAR(1);				-- Contante con valor NO
	DECLARE Con_SI       						CHAR(1);				-- Contante con valor SI
	DECLARE Est_Inactivo						CHAR(1);				-- Estatus inactivo
	DECLARE Pro_Registro						TINYINT;				-- Proceso de Registro de Cuenta Clabe del Cliente
	DECLARE Con_TipoFisica						CHAR(1);				-- Tipo de Persona fisica
	DECLARE Con_TipoFisicaA						CHAR(1);				-- Tipo de Persona fisica con actividad empresarial
	DECLARE Con_GenHombre						CHAR(1);				-- Genero Hombre
	DECLARE Con_GenMujer						CHAR(1);				-- Genero Mujer
	DECLARE TextoOriginal						VARCHAR(2); 			-- Mantiene texto original
	DECLARE Con_EspBlanco						CHAR(1);				-- Espacio en blanco
	DECLARE Con_CuentaAhorro					CHAR(2);				-- Tipo de Instrumento de Cuenta de Ahorro
	DECLARE Con_Credito							CHAR(2);				-- Tipo de Instrumento Credito
	
	-- Declaracion de Variables
	DECLARE Var_SPEICuentasClabeFisicaID		INT(11);				-- ID de tabla de registro de cuentas clabes
	DECLARE Var_ClienteID						INT(11);				-- ID de Cliente
	DECLARE Var_CuentaClabe						VARCHAR(18);			-- Cuenta Clabe
	DECLARE Var_FechaSistema					DATE;					-- Fecha de actual del sistema
	DECLARE Var_Estatus							CHAR(1);				-- Estatus				
	DECLARE Var_Nombre							VARCHAR(150);			-- Nombre del Cliente
	DECLARE Var_ApellidoPaterno					VARCHAR(50);			-- Apellido paterno del Cliente
	DECLARE Var_ApellidoMaterno					VARCHAR(50);			-- Apellido materno del Cliente
	DECLARE Var_Empresa							VARCHAR(15);			-- Nombre de la empresa con la que fue dada de alta en STP
	DECLARE Var_RFC								VARCHAR(18);			-- RFC del Cliente
	DECLARE Var_CURP							VARCHAR(18);			-- CURP del Cliente
	DECLARE Var_Genero							VARCHAR(1);				-- Genero del Cliente (M = Mujer, H = Hombre)
	DECLARE Var_FechaNacimiento					DATE;					-- Fecha de nacimiento del Cliente
	DECLARE Var_EstadoID						INT(11);				-- ID del estado de la republica
	DECLARE Var_Calle							VARCHAR(60);			-- Calle de la Direccion del cliente
	DECLARE Var_NumExterior						VARCHAR(10);			-- Numero exterior de la Direccion del cliente
	DECLARE Var_NumInterior						VARCHAR(15);			-- Numero interior de la Direccion del cliente
	DECLARE Var_CodigoPostal					VARCHAR(5);				-- Codigo Postal de la Direccion del cliente
	DECLARE Var_ClavePaisNacSTP					INT(11);				-- Clave de Pais de nacimiento del Catalogo de STP
	DECLARE Var_Correo							VARCHAR(50);			-- Correo electronico del cliente
	DECLARE Var_Identificacion					VARCHAR(20);			-- Numero de credencial para votar del Cliente (IFE/INE)
	DECLARE Var_Telefono						VARCHAR(20);			-- Numero telefonico del cliente
	DECLARE Var_TelCelular						VARCHAR(20);			-- Telefono celular del Cliente
	DECLARE Var_TelCasa							VARCHAR(20);			-- Telefono de casa del Cliente
	DECLARE Var_Firma							VARCHAR(172);			-- Firma electrónica valida para el registro
	DECLARE Var_Control	   						VARCHAR(200);			-- Numero de control.
	DECLARE Var_TipoPersona						CHAR(1);				-- Tipo de Persona (F = Fisica, M = Moral, A = Fisica con actividad empresarial)
	DECLARE Var_Consecutivo						INT(11);				-- Consecutivo
	DECLARE Var_EmpresaSTP						CHAR(15);				-- Nombre de la empresa de STP
	DECLARE Var_CreditoID						BIGINT(12);				-- ID del Credito
	DECLARE Var_CuentaAhoID						BIGINT(12);				-- ID de la Cuenta de Ahorro

	-- Asignacion de valor a constantes
	SET Cadena_Vacia    						:= '';					-- Cadena vacia
	SET Fecha_Vacia								:= '1900-01-01';		-- Fecha vacia
	SET Entero_Cero								:= 0;					-- Entero cero
	SET Con_NO									:= 'N';					-- Contante con valor NO
	SET Con_SI									:= 'S';					-- Contante con valor SI
	SET Est_Inactivo							:= 'I';					-- Estatus inactivo
	SET Pro_Registro							:= 1;					-- Proceso de Registro de Cuenta Clabe del Cliente
	SET Con_TipoFisica							:= 'F';					-- Tipo de Persona fisica
	SET Con_TipoFisicaA							:= 'A';					-- Tipo de Persona fisica con actividad empresarial
	SET Con_GenHombre							:= 'H';					-- Genero Hombre
	SET Con_GenMujer							:= 'M';					-- Genero Mujer
	SET TextoOriginal							:= 'OR';				-- Mantiene texto original
	SET Con_EspBlanco							:= ' ';					-- Espacio en blanco
	SET Con_CuentaAhorro						:= 'CH';				-- Tipo de Instrumento de Cuenta de Ahorro
	SET Con_Credito								:= 'CR';				-- Tipo de Instrumento Credito
	
	-- Asignacion de valores por defecto
	SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_CuentaClabe := IFNULL(Par_CuentaClabe, Cadena_Vacia);
	SET Par_Firma := IFNULL(Par_Firma, Cadena_Vacia);
	
    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEICUENTASCLABEPFISICAPRO');
				SET Var_Control = 'sqlException';
			END;
			
		IF(Par_NumPro = Pro_Registro) THEN
			IF(Par_CuentaClabe = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 1;
				SET	Par_ErrMen	:= "Especifique la Cuenta Clabe.";
				SET Var_Control := 'cuentaClabe';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Firma = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 2;
				SET	Par_ErrMen	:= "Especifique la firma para el registro de cuenta clabe.";
				SET Var_Control := 'firma';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;
			
			IF(Par_ClienteID <= Entero_Cero) THEN
				SET	Par_NumErr 	:= 3;
				SET	Par_ErrMen	:= "Especifique un ID de Cliente valido.";
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;
				
			SELECT 		ClienteID,				TipoPersona
				INTO 	Var_ClienteID,			Var_TipoPersona
				FROM CLIENTES 
				WHERE ClienteID = Par_ClienteID;
				
			IF(IFNULL(Var_ClienteID, Entero_Cero) = Entero_Cero) THEN
				SET	Par_NumErr 	:= 4;
				SET	Par_ErrMen	:= "No se encontro el cliente con el ID especificado.";
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;
			
			IF(Var_TipoPersona NOT IN (Con_TipoFisica, Con_TipoFisicaA)) THEN
				SET	Par_NumErr 	:= 5;
				SET	Par_ErrMen	:= "El cliente no se encuentra registrado como persona fisica o fisica con actividad empresarial.";
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;
			

			IF(Par_TipoInstrumento NOT IN (Con_CuentaAhorro, Con_Credito)) THEN
				SET	Par_NumErr 	:= 6;
				SET	Par_ErrMen	:= "Especifique un tipo de instrumento valido.";
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := 0;
				LEAVE ManejoErrores;
			END IF;

			IF(Par_TipoInstrumento = Con_CuentaAhorro) THEN
				SELECT 		CuentaAhoID
					INTO 	Var_CuentaAhoID
					FROM CUENTASAHO
					WHERE CuentaAhoID = Par_Instrumento;

				IF(IFNULL(Var_CuentaAhoID, Entero_Cero) = Entero_Cero) THEN
					SET	Par_NumErr 	:= 7;
					SET	Par_ErrMen	:= "Especifique un numero de Cuenta de Ahorro valido.";
					SET Var_Control := 'clienteID';
					SET Var_Consecutivo := 0;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			IF(Par_TipoInstrumento = Con_Credito) THEN
				SELECT 		CreditoID
					INTO 	Var_CreditoID
					FROM CREDITOS
					WHERE CreditoID = Par_Instrumento;

				IF(IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero) THEN
					SET	Par_NumErr 	:= 7;
					SET	Par_ErrMen	:= "Especifique un numero de Credito valido.";
					SET Var_Control := 'clienteID';
					SET Var_Consecutivo := 0;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SELECT 		FechaSistema
				INTO 	Var_FechaSistema
				FROM PARAMETROSSIS;
			
			SELECT 		CONCAT(IFNULL(C.PrimerNombre, Cadena_Vacia), ' ', IFNULL(C.SegundoNombre, Cadena_Vacia), ' ', IFNULL(C.TercerNombre, Cadena_Vacia)) as Nombre,
						C.ApellidoPaterno,		C.ApellidoMaterno,		C.RFC,					C.CURP,				IF(C.Sexo = 'M', Con_GenHombre, Con_GenMujer) as Genero,
						C.FechaNacimiento,		C.EstadoID,				P.ClaveSTP,				C.Correo,			C.TelefonoCelular,
						C.Telefono
				INTO 	Var_Nombre,
						Var_ApellidoPaterno,	Var_ApellidoMaterno,	Var_RFC,				Var_CURP,			Var_Genero,
						Var_FechaNacimiento,	Var_EstadoID,			Var_ClavePaisNacSTP,	Var_Correo,			Var_TelCelular,
						Var_TelCasa
				FROM CLIENTES C
				LEFT JOIN PAISES P ON P.PaisID = C.LugarNacimiento
				WHERE ClienteID = Par_ClienteID;
				
			SET Var_Nombre := TRIM(Var_Nombre);
			SET Var_Nombre := FNLIMPIACARACTERESGEN(Var_Nombre, TextoOriginal);
			SET Var_ApellidoPaterno := IFNULL(Var_ApellidoPaterno, Cadena_Vacia);
			SET Var_ApellidoMaterno := IFNULL(Var_ApellidoMaterno, Cadena_Vacia);
			SET Var_RFC := IFNULL(Var_RFC, Cadena_Vacia);
			SET Var_CURP := IFNULL(Var_CURP, Cadena_Vacia);
			SET Var_Genero := IFNULL(Var_Genero, Cadena_Vacia);
			SET Var_FechaNacimiento := IFNULL(Var_FechaNacimiento, Fecha_Vacia);
			SET Var_Correo := IFNULL(Var_Correo, Cadena_Vacia);
			SET Var_Telefono := IFNULL(Var_TelCelular,  IFNULL(Var_TelCasa, Cadena_Vacia));
			SET Var_ClavePaisNacSTP := IFNULL(Var_ClavePaisNacSTP, Entero_Cero);

			IF(Var_RFC = Cadena_Vacia AND Var_CURP = Cadena_Vacia) THEN
				SET	Par_NumErr 	:= 8;
				SET	Par_ErrMen	:= "Actualice el R.F.C y la C.U.R.P del Cliente.";
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := Par_ClienteID;
				LEAVE ManejoErrores;
			END IF;

			IF(Var_ClavePaisNacSTP = Entero_Cero) THEN
				SET	Par_NumErr 	:= 9;
				SET	Par_ErrMen	:= "Actualice el pais de nacimiento del Cliente.";
				SET Var_Control := 'clienteID';
				SET Var_Consecutivo := Par_ClienteID;
				LEAVE ManejoErrores;
			END IF;
				
				
			SELECT 		Calle,				NumeroCasa,				NumInterior,				CP
				INTO 	Var_Calle,			Var_NumExterior,		Var_NumInterior,			Var_CodigoPostal	
				FROM DIRECCLIENTE
				WHERE ClienteID = Par_ClienteID 
				AND Oficial = Con_SI;
				
			SET Var_Calle := IFNULL(Var_Calle, Cadena_Vacia);
			SET Var_NumExterior := IFNULL(Var_NumExterior, Cadena_Vacia);
			SET Var_NumInterior := IFNULL(Var_NumInterior, Cadena_Vacia);
			SET Var_CodigoPostal := IFNULL(Var_CodigoPostal, Cadena_Vacia);
			
			SELECT EmpresaSTP
				INTO Var_EmpresaSTP
				FROM PARAMETROSSPEI;
			
			CALL FOLIOSAPLICAACT('SPEICUENTASCLABEPFISICA', Var_SPEICuentasClabeFisicaID);
		
			INSERT INTO SPEICUENTASCLABEPFISICA (
					CuentaClabePFisicaID,			ClienteID,					CuentaClabe,				TipoInstrumento,			Instrumento,	
					FechaCreacion,					Estatus,					Comentario,					PIDTarea,					Nombre,
					ApellidoPaterno,				ApellidoMaterno,			EmpresaSTP,					RFC,						CURP,
					Genero,							FechaNacimiento,			EstadoID,					Calle,						NumExterior,
					NumInterior,					CodigoPostal,				ClavePaisNacSTP,			CorreoElectronico,			Identificacion,
					Telefono,						Firma,						IDRespuesta,				DescripcionRespuesta,		NumIntentos,
					EmpresaID,						Usuario,					FechaActual,				DireccionIP,				ProgramaID,
					Sucursal,						NumTransaccion
				)
				VALUES (
					Var_SPEICuentasClabeFisicaID,	Par_ClienteID,				Par_CuentaClabe,			Par_TipoInstrumento,		Par_Instrumento,
					Var_FechaSistema,				Est_Inactivo,				Cadena_Vacia,				Cadena_Vacia,				Var_Nombre,
					Var_ApellidoPaterno,			Var_ApellidoMaterno,		Var_EmpresaSTP,				Var_RFC,					Var_CURP,
					Var_Genero,						Var_FechaNacimiento,		Var_EstadoID,				Var_Calle,					Var_NumExterior,
					Var_NumInterior,				Var_CodigoPostal,			Var_ClavePaisNacSTP,		Var_Correo,					Cadena_Vacia,
					Var_Telefono,					Par_Firma,					Entero_Cero,				Cadena_Vacia,				Entero_Cero,
					Aud_EmpresaID,					Aud_Usuario,				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,
					Aud_Sucursal,					Aud_NumTransaccion
				);

			SET Par_NumErr	:= 000;
			SET	Par_ErrMen 	:= 'Cuenta clabe registrada correctamente.';
			SET Var_Control := 'CuentaClabe';
			SET Var_Consecutivo := Var_SPEICuentasClabeFisicaID;
		END IF;
	END ManejoErrores;
	
	IF (Par_Salida = Con_SI) THEN
		SELECT  Par_NumErr 	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Var_Consecutivo AS conscutivo;
	END IF;

END TerminaStore$$ 
