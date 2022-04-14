-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTESWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTESWSALT`;
DELIMITER $$

CREATE PROCEDURE `CLIENTESWSALT`(
# ============ SP para realizar alta de socios utilizando el WS de Alta de Socios =============
    Par_Nombre1                 VARCHAR(50), # Primer Nombre del Cliente
    Par_Nombre2                 VARCHAR(50), # Segundo Nombre del Cliente
    Par_Nombre3                 VARCHAR(50), # Tercer Nombre del Cliente
	Par_ApellidoPat             VARCHAR(50), # Apellido paterno del cliente
	Par_ApellidoMat   			VARCHAR(50), # Apellido materno del cliente
	Par_FechaNac  		        VARCHAR(50), # Fecha de nacimiento
	Par_Rfc     				VARCHAR(13), # RFC del cliente
	Par_Curp 				    VARCHAR(18), # Curp del cliente
    Par_Monto                   DECIMAL(12,2),# Monto aportado por el Cliente
	Par_SucursalOri 			INT,         # Sucursal de Origen

    Par_Mail      			    VARCHAR(50), # Correo electronico del cliente
	Par_PaisNaci 		        INT,         # Lugar de nacimiento
	Par_EstadoId 	            INT,         # estadoID
    Par_Nacionalidad            CHAR(1),     # Nacional o Extranjera
	Par_PaisResi                INT,         # Pais de residencia del cliente
    Par_Sexo                    CHAR(1),     # Sexo del Cliente
	Par_Telefono                VARCHAR(20), #Telefono oficial del cliente
	Par_SectorGral     		    INT ,        # Sector General
	Par_ActividadBMX  			VARCHAR(15), # Actividad BMX hace referencia a la tabla ACTIVIDADESBMX
	Par_ActividadFR  			BIGINT(20),  # Actividad FR hace referencia a la tabla ACTIVIDADESFR

    Par_PromotorIni		        INT,         # Promotor Actual
	Par_PromotorAct 			INT,         # Promotor Inicial
    Par_EsMenor                 CHAR(1),     # Socio es menor de edad
	Par_Numero 					VARCHAR(20), # numero de empleado
	Par_TipDireccion       		INT,         # Tipo de direccion
	Par_EntidadFed		        INT,         # Numero del Estado donde vive el cliente
	Par_Municipio 				INT,         # Numero del Municipio donde vive el cliente
	Par_Localidad 				INT,         # Numero de la Localidad donde vive el vliente
	Par_Colonia 				INT,         # Numero de la Colonia donde vive el cliente
	Par_Calle 					VARCHAR(50), # Nombre de la calle
	Par_NumDireccion 		    CHAR(10),    # Numero de la vivienda del cliente

    Par_CodigoPostal 			CHAR(5),     # Codigo postal
	Par_Oficial 				VARCHAR(1),  # Si la direccion es la oficial
	Par_FolioIdentifi 	     	VARCHAR(30), # Folio de la identificacion proporcionada
	Par_TipoIdentif 		    INT,         # Tipo de identificacion
	Par_EsOficial 				VARCHAR(1),  # Si la identificacion es oficial
	Par_FechaExp                DATE,        # Fecha de Expedicion de la identificacion
	Par_FechaVen                DATE,        # Fecha de vencimiento de la identificacion
    Par_Folio_Pda		        VARCHAR(20), # Folio generado por el PDA (Por ahora no utilizado)
    Par_Id_Usuario              VARCHAR(100),# ID del usuario
	Par_Clave			        VARCHAR(45), # Contrasenia del usuario
	Par_Dispositivo		        VARCHAR(40), # Dispositivo del que se genera el movimiento (Por ahora no utilizado)

	-- Parametros de Aditoria
	Par_EmpresaID		        INT,
	Aud_Usuario			        INT,
	Aud_FechaActual		  		DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT,
	Aud_NumTransaccion			BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CodigoResp		INT(1);
	DECLARE Var_CodigoDesc		VARCHAR(100);
	DECLARE Var_FechaOper       DATE;

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Entero_Cero             INT;
	DECLARE Estatus_Activo	        CHAR(1);
	DECLARE SalidaSI                CHAR(1);
	DECLARE SalidaNO                CHAR(1);
	DECLARE Var_ClienteId           INT;
	DECLARE Decimal_Cero	        DECIMAL(12,2);
	DECLARE Var_FechaAutoriza	    VARCHAR(20);
	DECLARE Var_NumErr		        INT(11);
	DECLARE Var_MenErr		        VARCHAR(400);
	DECLARE Fecha_Vacia             DATE;
	DECLARE Bigint_Cero     		BIGINT;
	DECLARE Var_Per     	    	CHAR(1);
	DECLARE Var_Clasif              CHAR(1);
	DECLARE Var_MotAper             CHAR(1);
	DECLARE Var_Isr                 CHAR(1);
	DECLARE Var_Iva                 CHAR(1);
	DECLARE Var_Ide                 CHAR(1);
	DECLARE Var_Riesg               CHAR(1);
	DECLARE Var_RegHacien           CHAR(1);

	DECLARE Var_PrimerNom           VARCHAR(50);
	DECLARE Var_SegundoNom          VARCHAR(50);
	DECLARE Var_TercerNom           VARCHAR(50);
	DECLARE Var_ApellidoPat         VARCHAR(50);
	DECLARE Var_ApellidoMat         VARCHAR(50);

	DECLARE Var_ActInegi            INT;
	DECLARE Var_ActFomur            INT;
	DECLARE Var_Nacional            CHAR(1);
	DECLARE Var_Extranjera          CHAR(1);
	DECLARE Var_Clave               VARCHAR(40);
	DECLARE Var_idUsuario           VARCHAR(400);
	DECLARE Var_NomColonia          VARCHAR(200);
	DECLARE Var_Femenino            CHAR(1);
	DECLARE Var_Masculino           CHAR(1);
	DECLARE Var_Moneda              INT;
	DECLARE Var_Poliza              INT;

	DECLARE Var_AltaEncPoliza       CHAR(1);
	DECLARE Var_AltaDetPol          CHAR(1);
	DECLARE Var_AltaEncPoli         CHAR(1);

	DECLARE Var_UsuarioID		INT(11);
	DECLARE Var_SucursalID		INT(11);
	DECLARE Var_CajaID			INT(11);

	DECLARE Var_EntApor         INT;
	DECLARE Var_SalApor         INT;
	DECLARE Var_Entrada         INT;
	DECLARE Var_Monedas         INT;
	DECLARE Var_Parentesco      INT;

	DECLARE Var_OficialSI       CHAR(1);
	DECLARE Var_OficialNO       CHAR(1);
	DECLARE Var_EsMenorSI       CHAR(1);
	DECLARE Var_EsMenorNO       CHAR(1);
	DECLARE Var_Ciudadano       CHAR(1);
	DECLARE Var_PaisIDDom		INT(11);		-- País ID de la dirección
	DECLARE Var_AniosRes		INT(11);		-- Años de residencia

	-- Asignacion de Constantes
	Set Estatus_Activo	   := 'A';        # Estatud del usuario cuando estÃ¡ activo
	Set Cadena_Vacia       := '';
	Set Entero_Cero        :=  0;
	Set SalidaSI           := 'S';        # El Store SI genera una Salida
	set	SalidaNO 	   	   := 'N';	      # El Store NO genera una Salida
	Set Decimal_Cero	   :=  0.00;
	Set	Var_ClienteId      :=  0;         # Valor que toma el ID del cliente para insertar en tabla direccliente e identificliente
	Set	Fecha_Vacia		   := '1900-01-01';
	Set Bigint_Cero        :=  0;
	Set Var_Per     	   := 'F';        # Tipo de persona FISICA
	Set Var_Clasif         := 'I';        # Clasificacion
	Set Var_MotAper        := '3';        # Motivo de apertura
	Set Var_Isr            := 'S';        # Valor si el cliente paga ISR
	Set Var_Iva            := 'S';        # Valor si el cliente para IVA
	Set Var_Ide            := 'S';        # Valor si el cliente paga IDE
	Set Var_Riesg          := 'B';        # Valor del riesgo
	Set Var_RegHacien      := 'N';        # Valor si el cliente no estÃ¡ registrado en hacienda
	Set Var_Nacional       := 'N';        # Valor de Nacionalidad Nacional
	Set Var_Extranjera     := 'E';        # Valor de Nacionalidad Extranjera
	Set Var_NomColonia     := '';         # Nombre de la Colonia
	Set Var_Femenino       := 'F';        # Sexo del Cliente si es Femenino
	Set Var_Masculino      := 'M';        # Sexo del Cliente si es Masculino
	Set Var_Poliza         :=  0;

	Set Var_Parentesco	   := 40;
	Set Var_AltaEncPoliza  := 'S';
	Set Var_AltaDetPol     := 'S';
	Set Var_AltaEncPoli    := 'N';

	Set Var_OficialSI      := 'S';
	Set Var_OficialNO      := 'N';
	Set Var_EsMenorSI      := 'S';
	Set Var_EsMenorNO      := 'N';
	Set Var_Ciudadano      := 'C';


	Set Var_ActInegi       := 99999;      # Actividad INEGI hace referencia a la tabla ACTIVIDADESINEGI
	Set Var_ActFomur       := 99999999;   # Actividad FOMUR hace referencia a la tabla ACTIVIDADESFOMUR
	Set Var_EntApor        := 64;         # Tipo de Transaccion entrada
	Set Var_SalApor        := 65;         # Tipo de Transaccion salida
	Set Var_Entrada        := 1;
	Set Var_Monedas        := 7;
	-- Asignacion de variables
	Set	Var_CodigoResp	   :=  0;
	Set	Var_CodigoDesc	   :=  'Transaccion Rechazada';
	Set Var_FechaAutoriza  :=   CONCAT(CURRENT_DATE,'T',CURRENT_TIME);
	Set Var_FechaOper      := (select FechaSistema from PARAMETROSSIS);
	SET Var_PaisIDDom		:= 0;			-- Valor asignado por defecto
	SET Var_AniosRes		:= 0;			-- Valor asignado por defecto

	SELECT UsuarioID,  '127.0.0.1' ,	EmpresaID,	SucursalUsuario
		FROM USUARIOS
		WHERE Clave = Par_Id_Usuario
			AND Contrasenia = Par_Clave
			AND Estatus = Estatus_Activo
	INTO Aud_Usuario,	Aud_DireccionIP,	Par_EmpresaID,	Aud_Sucursal;
	SET Aud_FechaActual	:= NOW();

	SELECT Usu.UsuarioID, Usu.SucursalUsuario, CajaID
		FROM CAJASVENTANILLA Ven,
			 USUARIOS Usu
		WHERE Ven.UsuarioID = Usu.UsuarioID
			AND Usu.UsuarioID = Aud_Usuario
		LIMIT 1
	INTO Var_UsuarioID, Var_SucursalID, Var_CajaID;

ManejoErrores:BEGIN

	IF NOT EXISTS(SELECT UsuarioID
			FROM USUARIOS
			WHERE Clave = Par_Id_Usuario
			AND Contrasenia = Par_Clave
			AND Estatus = Estatus_Activo)then
		LEAVE ManejoErrores;

	END IF;

	  #-----------------Validacion de campos---------------#

		   IF(IFNULL(Par_Nombre1, Cadena_Vacia)) = Cadena_Vacia THEN
				 LEAVE ManejoErrores;
			 END IF;

		   IF(IFNULL(Par_Nombre2, Cadena_Vacia) = Cadena_Vacia)then
			SET Par_Nombre2 = Cadena_Vacia;
			END IF;

		   IF(IFNULL(Par_Nombre3, Cadena_Vacia) = Cadena_Vacia)then
			SET Par_Nombre3 = Cadena_Vacia;
			END IF;


		   IF(IFNULL(Par_ApellidoPat, Cadena_Vacia)) = Cadena_Vacia THEN
			  LEAVE ManejoErrores;
			END IF;

		   IF(IFNULL(Par_ApellidoMat, Cadena_Vacia)) = Cadena_Vacia THEN
			  LEAVE ManejoErrores;
			END IF;

		  IF(IFNULL(Par_FechaNac, Fecha_Vacia)) = Fecha_Vacia THEN
			  LEAVE ManejoErrores;
		   END IF;


		 IF(IFNULL(Par_Curp, Cadena_Vacia)) = Cadena_Vacia THEN
			 LEAVE ManejoErrores;
		   END IF;

		 IF(IFNULL(Par_SucursalOri, Entero_Cero)) = Entero_Cero THEN
			 LEAVE ManejoErrores;
		 END IF;

		IF(IFNULL(Par_Mail, Cadena_Vacia)) = Cadena_Vacia THEN
			LEAVE ManejoErrores;
		 END IF;

		IF(IFNULL(Par_PaisNaci, Entero_Cero)) = Entero_Cero THEN
		   LEAVE ManejoErrores;
		 END IF;

		IF(IFNULL(Par_EstadoId, Entero_Cero)) = Entero_Cero THEN
			LEAVE ManejoErrores;
		 END IF;

		IF(IFNULL(Par_Nacionalidad, Cadena_Vacia)) = Cadena_Vacia THEN
			LEAVE ManejoErrores;
		 END IF;

		 IF(IFNULL(Par_PaisResi, Entero_Cero)) = Entero_Cero THEN
		   LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_Sexo, Cadena_Vacia)) = Cadena_Vacia THEN
		   LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_Telefono, Cadena_Vacia)) = Cadena_Vacia THEN
			LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_PromotorIni, Entero_Cero)) = Entero_Cero THEN
		   LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_PromotorAct, Entero_Cero)) = Entero_Cero THEN
			LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_Numero, Cadena_Vacia)) = Cadena_Vacia THEN
		   LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_TipDireccion, Entero_Cero)) = Entero_Cero THEN
		   LEAVE ManejoErrores;
		   END IF;

		 IF(IFNULL(Par_EntidadFed, Entero_Cero)) = Entero_Cero THEN
		   LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_Municipio, Entero_Cero)) = Entero_Cero THEN
		  LEAVE ManejoErrores;
		   END IF;

		 IF(IFNULL(Par_Localidad, Entero_Cero)) = Entero_Cero THEN
		  LEAVE ManejoErrores;
		  END IF;

		 IF(IFNULL(Par_Colonia, Entero_Cero)) = Entero_Cero THEN
		   LEAVE ManejoErrores;
		  END IF;

		  IF(ifnull(Par_Calle, Cadena_Vacia)) = Cadena_Vacia THEN
		   LEAVE ManejoErrores;
		   END IF;

		  IF(ifnull(Par_NumDireccion, Cadena_Vacia)) = Cadena_Vacia THEN
		   LEAVE ManejoErrores;
		   END IF;

		  IF(ifnull(Par_CodigoPostal, Cadena_Vacia)) = Cadena_Vacia THEN
		   LEAVE ManejoErrores;
		   END IF;

		  IF(ifnull(Par_Oficial, Cadena_Vacia)) = Cadena_Vacia THEN
			LEAVE ManejoErrores;
		   END IF;

		/* validaciones para socios mayores *************** */
		IF(Par_EsMenor = Var_EsMenorNO)THEN
			IF EXISTS(SELECT ClienteID
					  FROM CLIENTES
					  WHERE RFC = Par_Rfc)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_FolioIdentifi, Cadena_Vacia)) = Cadena_Vacia THEN
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_TipoIdentif, Entero_Cero)) = Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_EsOficial, Cadena_Vacia)) = Cadena_Vacia THEN
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_FechaExp, Fecha_Vacia)) = Fecha_Vacia THEN
				LEAVE ManejoErrores;
			END IF;

			IF(ifnull(Par_FechaVen, Fecha_Vacia)) = Fecha_Vacia THEN
				LEAVE ManejoErrores;
			END IF;
			-- Es Oficial la Identificacion
			if(Par_EsOficial != Var_OficialSI and Par_EsOficial != Var_OficialNO) then
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_SectorGral, Entero_Cero)) = Entero_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ActividadBMX, Cadena_Vacia)) = Cadena_Vacia THEN
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_ActividadFR, Bigint_Cero)) = Bigint_Cero THEN
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_Rfc, Cadena_Vacia)) = Cadena_Vacia THEN
			 LEAVE ManejoErrores;
		   END IF;

		else
			set Par_SectorGral		:= 999;
			set Par_ActividadBMX 	:= 9999999999;
			set Par_ActividadFR 	:= 999999999999;
		END IF;

	-- Validaciones de Valores referencias a otras tablas
	-- Pais
	IF NOT EXISTS(SELECT PaisID FROM PAISES
				WHERE PaisID = Par_PaisNaci)THEN
		LEAVE ManejoErrores;
	END IF;


	IF NOT EXISTS(SELECT PaisID FROM PAISES
				WHERE PaisID = Par_PaisResi)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Estados

	IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
				WHERE EstadoID = Par_EstadoId)THEN
		LEAVE ManejoErrores;
	END IF;


	IF NOT EXISTS(SELECT EstadoID FROM ESTADOSREPUB
				WHERE EstadoID = Par_EntidadFed)THEN
		LEAVE ManejoErrores;
	END IF;
	-- Municipios

	IF NOT EXISTS(SELECT MunicipioID FROM MUNICIPIOSREPUB
				WHERE MunicipioID = Par_Municipio
				AND EstadoID = Par_EntidadFed )THEN
		LEAVE ManejoErrores;
	END IF;


	-- Localidad

	IF NOT EXISTS(SELECT LocalidadID FROM LOCALIDADREPUB
				WHERE LocalidadID = Par_Localidad
				AND EstadoID = Par_EntidadFed
				AND MunicipioID = Par_Municipio)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Colonias
	IF NOT EXISTS(SELECT ColoniaID FROM COLONIASREPUB
				WHERE EstadoID = Par_EntidadFed
				AND MunicipioID = Par_Municipio
				AND ColoniaID = Par_Colonia
				AND CodigoPostal = Par_CodigoPostal)THEN
		LEAVE ManejoErrores;

		 END IF;

	-- Actividades BMX
	IF NOT EXISTS(SELECT ActividadBMXID FROM ACTIVIDADESBMX
				WHERE ActividadBMXID = Par_ActividadBMX)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Actividades FR
	IF NOT EXISTS(SELECT ActividadFRID FROM ACTIVIDADESFR
				WHERE ActividadFRID = Par_ActividadFR)THEN
		LEAVE ManejoErrores;
	END IF;

	-- Nacionalidad
	if(Par_Nacionalidad != Var_Nacional and Par_Nacionalidad != Var_Extranjera) then
					LEAVE ManejoErrores;
			 END IF;


	-- Sexo
	if(Par_Sexo != Var_Femenino and Par_Sexo != Var_Masculino) then
					LEAVE ManejoErrores;
			 END IF;

	-- Es Menor el cliente
	if(Par_EsMenor != Var_EsMenorSI and Par_EsMenor != Var_EsMenorNO) then
					LEAVE ManejoErrores;
			 END IF;


	-- Es Oficial la direcciÃ³n
	if(Par_Oficial != Var_OficialSI and Par_Oficial != Var_OficialNO) then
					LEAVE ManejoErrores;
			 END IF;


	/*se convierten a mayusculas*/
	set Par_Nombre1		:= upper(Par_Nombre1);
	set Par_Nombre2		:= upper(Par_Nombre2);
	set Par_ApellidoPat	:= upper(Par_ApellidoPat);
	set Par_ApellidoMat	:= upper(Par_ApellidoMat);
	set Par_Rfc			:= upper(Par_Rfc);

	IF(Par_EsMenor = Var_EsMenorNO)THEN

		-- Se modifica el llamado para incluir un parametro de entrada. Cardinal Sistemas Inteligentes
		CALL CLIENTESALT(Par_SucursalOri,		Var_Per,				Cadena_Vacia,		Par_Nombre1,			Par_Nombre2,
						 Par_Nombre3,			Par_ApellidoPat,		Par_ApellidoMat,	Par_FechaNac,			Par_PaisNaci,
						 Par_EstadoId,			Par_Nacionalidad,		Par_PaisResi,		Par_Sexo,				Par_Curp,
						 Par_Rfc,				Cadena_Vacia,			Cadena_Vacia,		Par_Telefono,			Par_Mail,
						 Cadena_Vacia,			Entero_Cero,			Par_Rfc,			Entero_Cero,			Cadena_Vacia,
						 Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,		Decimal_Cero,			Cadena_Vacia,
						 Cadena_Vacia,			Var_Clasif,				Var_MotAper,		Var_Isr,				Var_Iva,
						 Var_Ide,				Var_Riesg,				Par_SectorGral,		Par_ActividadBMX,		Var_ActInegi,
						 Entero_Cero,			Par_ActividadFR,		Var_ActFomur,		Par_PromotorIni,		Par_PromotorAct,
						 Entero_Cero,			Par_EsMenor,			Entero_Cero,		Var_RegHacien,			Entero_Cero,
						 Entero_Cero,			Cadena_Vacia,			Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,
						 Cadena_Vacia,			Entero_Cero,			Entero_Cero,		Entero_Cero,			Fecha_Vacia,
						 Entero_Cero,			Cadena_Vacia,			Entero_Cero,		Fecha_Vacia,			Entero_Cero,
						 Cadena_Vacia,			Cadena_Vacia,			Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,
						 Par_PaisNaci,			Par_EmpresaID,			SalidaNO,			Var_NumErr,				Var_MenErr,
						 Var_ClienteId,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion
		);
		-- Fin de modificacion del llamado a CLIENTESALT. Cardinal Sistemas Inteligentes

		 Set Entero_Cero  := 0;

		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;



		call IDENTIFICLIENTEALT(Var_ClienteId,         Par_TipoIdentif,      Par_EsOficial,         Par_FolioIdentifi,   Par_FechaExp,
								Par_FechaVen,          Par_EmpresaID,        SalidaNO,              Var_NumErr,          Var_MenErr,
								Aud_Usuario,           Aud_FechaActual,      Aud_DireccionIP,       Aud_ProgramaID,      Aud_Sucursal,
								Aud_NumTransaccion);

		Set Entero_Cero  := 0;

		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


		Set Var_Moneda  := (select MonedaBaseID
								 from PARAMETROSSIS);



		call APORTACIONSOCIOPRO(Var_ClienteId,      Aud_NumTransaccion,     Par_Monto,          Var_Moneda,     Var_AltaEncPoliza,
								Var_SucursalID,     Var_Poliza,             Var_AltaDetPol,     Var_CajaID,     Aud_Usuario,
								SalidaNO,           Var_NumErr,             Var_MenErr,         Par_EmpresaID,  Aud_Usuario,
								Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

		Set Entero_Cero  := 0;


		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


		call CAJASMOVSALT(Var_SucursalID,  Var_CajaID,     Var_FechaOper,       Aud_NumTransaccion,    Var_Moneda,
						  Par_Monto,       Entero_Cero,    Var_EntApor,         Var_ClienteId,         Var_ClienteId,
						  Entero_Cero,     Entero_Cero,    SalidaNO,            Var_NumErr,            Var_MenErr,
						  Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,       Aud_ProgramaID,
						  Aud_Sucursal,    Aud_NumTransaccion);
		Set Entero_Cero  := 0;

		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


		call CAJASMOVSALT(Var_SucursalID,  Var_CajaID,        Var_FechaOper,       Aud_NumTransaccion,    Var_Moneda,
						  Par_Monto,       Entero_Cero,       Var_SalApor,         Var_ClienteId,         Var_ClienteId,
						  Entero_Cero,     Entero_Cero,       SalidaNO,            Var_NumErr,            Var_MenErr,
						  Par_EmpresaID,   Aud_Usuario,       Aud_FechaActual,     Aud_DireccionIP,       Aud_ProgramaID,
						  Aud_Sucursal,    Aud_NumTransaccion);

		Set Entero_Cero  := 0;

		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


		call DENOMINAMOVSALT(Var_SucursalID,     Var_CajaID,       Aud_FechaActual,     Aud_NumTransaccion,     Var_Entrada,
							 Var_Monedas,        Par_Monto,        Par_Monto,           Var_Moneda,             Var_AltaEncPoli,
							 Var_ClienteId,      Var_ClienteId,    SalidaNO,            Par_EmpresaID,          Cadena_Vacia,
							 Var_ClienteId,     Var_Poliza,       Var_NumErr,          Var_MenErr,             Entero_Cero,
							 Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,     Aud_ProgramaID,         Aud_Sucursal,
							 Aud_NumTransaccion);

		 Set Entero_Cero  := 0;

		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


	ELSE


		call SOCIOMENORALT(
			Var_SucursalID,		Var_Per,				Var_Ciudadano,		Par_Nombre1,        Par_Nombre2,
			Par_Nombre3,        Par_ApellidoPat,        Par_ApellidoMat,    Par_FechaNac,       Par_PaisNaci,
			Par_EstadoId,       Par_Nacionalidad,       Par_PaisResi,       Par_Sexo,           Par_Curp,
			Par_Rfc,            Cadena_Vacia,           Cadena_Vacia,       Par_Telefono,       Par_Mail,
			Cadena_Vacia,       Entero_Cero,            Par_Rfc,            Entero_Cero,        Cadena_Vacia,
			Entero_Cero,        Cadena_Vacia,           Cadena_Vacia,       Decimal_Cero,       Cadena_Vacia,
			Var_Clasif,         Var_MotAper,            Var_Isr,            Var_Iva,            Var_Ide,
			Var_Riesg,          Par_SectorGral,         Par_ActividadBMX,   Var_ActInegi,       Entero_Cero,
			Par_ActividadFR,	Var_ActFomur,           Par_PromotorIni,    Par_PromotorAct,	Entero_Cero,
			Par_EsMenor,		Entero_Cero,			Cadena_Vacia,		Var_Parentesco,		Par_Telefono,
			Par_PromotorIni,	Par_PromotorIni,		Par_EmpresaID,		SalidaNO,			Var_NumErr,
			Var_MenErr,			Var_ClienteId,          Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);

		Set Entero_Cero  := 0;

		IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
	END IF;


	IF NOT EXISTS(SELECT ClienteID FROM CLIENTES WHERE ClienteID = Var_ClienteId) THEN
					LEAVE ManejoErrores;
				 END IF;


	Set Var_NomColonia := (SELECT Asentamiento FROM COLONIASREPUB
				WHERE EstadoID = Par_EntidadFed
				AND MunicipioID = Par_Municipio
				AND ColoniaID = Par_Colonia
				AND CodigoPostal = Par_CodigoPostal);

	/*se convierten a mayusculas*/
	set Par_Calle		:= upper(Par_Calle);
	call DIRECCLIENTEALT(Var_ClienteId,    Par_TipDireccion,      Par_EntidadFed,           Par_Municipio,       Par_Localidad,
						 Par_Colonia,      Var_NomColonia,        Par_Calle,                Par_NumDireccion,    Cadena_Vacia,
						 Cadena_Vacia,     Cadena_Vacia,          Cadena_Vacia,             Par_CodigoPostal,    Cadena_Vacia,
						 Cadena_Vacia,     Cadena_Vacia,          Par_Oficial,              Cadena_Vacia,        Par_EmpresaID,
						 Cadena_Vacia,     Cadena_Vacia,          Cadena_Vacia,				Var_PaisIDDom,		 Var_AniosRes,
						 SalidaNO,         Var_NumErr,		  	  Var_MenErr,	   			Aud_Usuario,         Aud_FechaActual,
						 Aud_DireccionIP,  Aud_ProgramaID,		  Aud_Sucursal,	   			Aud_NumTransaccion);

	 Set Entero_Cero  := 0;

	IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;


	IF(IFNULL(cast(Var_NumErr as unsigned),Entero_Cero) != Entero_Cero) THEN
					LEAVE ManejoErrores;
			ELSE

					SET Var_CodigoResp		:= 1;
					SET Var_CodigoDesc		:= 'Transaccion Aceptada';

				 END IF;

	END ManejoErrores;



	# =========================== LANZA VALORES DE RESPUESTA ===========================
	IF (Var_CodigoResp = Entero_Cero)THEN

			  SELECT Var_FechaAutoriza		    AS AutFecha,
					 Var_CodigoResp 	  	    AS CodigoResp,
					 Var_CodigoDesc         	AS CodigoDesc,
					 'false' 				    AS EsValido,
					 Entero_Cero				AS FolioAut,
					 Entero_Cero                AS NumSocio,
					 Var_MenErr					AS MensajeError;

	ELSE

			  SELECT Var_FechaAutoriza		    AS AutFecha,
					 Var_CodigoResp 	  	    AS CodigoResp,
					 Var_CodigoDesc         	AS CodigoDesc,
					 'true' 				    AS EsValido,
					 Aud_NumTransaccion	 	 	AS FolioAut,
					 Var_ClienteId              AS NumSocio,
					 Var_MenErr					AS MensajeError;
	END IF;

END TerminaStore$$