-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANALTACLIENTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANALTACLIENTEPRO`;
DELIMITER $$

CREATE PROCEDURE `BANALTACLIENTEPRO`(



	Par_Telefono			VARCHAR(20),
	Par_PrimerNombre		VARCHAR(50),
	Par_SegundoNombre		VARCHAR(50),
	Par_ApellidoPaterno		VARCHAR(50),
	Par_ApellidoMaterno		VARCHAR(50),

	Par_FechaNacimiento		DATE,
	Par_EdoNacID			INT(11),
	Par_EstadoID			INT(11),
	Par_MunicipioID			INT(11),
	Par_ColoniaID			INT(11),

	Par_LocalidadID			INT(11),
	Par_Calle				VARCHAR(100),
	Par_NoInterior			VARCHAR(20),
	Par_NoExterior			VARCHAR(20),
	Par_CodPostal			VARCHAR(20),
	Par_Genero				CHAR(1),

	Par_Curp				VARCHAR(45),
	Par_Rfc					VARCHAR(30),
	Par_TelefonoFijo		VARCHAR(20),
	Par_Correo				VARCHAR(50),
	Par_OcupacionID			INT(11),

	Par_RespPregSecreta		VARCHAR(100),
	Par_PreguntaSecretaID	BIGINT(20),
	Par_Contrasenia			VARCHAR(50),
	Par_ImagenPhishingID	BIGINT(20),
	Par_ActividadBMXID		BIGINT(20),
	Par_PaisNacional		INT(11),

    Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
    INOUT Par_ClienteID		INT(11),

    Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_PrimerNombre			VARCHAR(50);
	DECLARE Var_SegundoNombre			VARCHAR(50);
	DECLARE Var_ApellidoPaterno			VARCHAR(50);
	DECLARE Var_ApellidoMaterno			VARCHAR(50);
	DECLARE Var_FechaNacimiento			DATE;

	DECLARE Var_LugarNacimientoID		INT(11);
	DECLARE Var_Genero					CHAR(1);
	DECLARE Var_Curp					VARCHAR(45);
	DECLARE Var_Rfc						VARCHAR(30);

	DECLARE Var_Calle					VARCHAR(100);
	DECLARE Var_CodigoPostal			VARCHAR(20);
	DECLARE Var_EstadoID				INT(11);
	DECLARE Var_MunicipioID				INT(11);
	DECLARE Var_LocalidadID				INT(11);

	DECLARE Var_ColoniaID				INT(11);
	DECLARE Var_Correo					VARCHAR(50);
	DECLARE Var_NoExterior				VARCHAR(20);

	DECLARE Var_Contrasenia				VARCHAR(50);
	DECLARE Var_OcupacionID				INT(11);
	DECLARE Var_ActBMX					VARCHAR(15);
	DECLARE Var_ActividadFOMUR			INT(11);
	DECLARE Var_ActividadFR				BIGINT(20);

	DECLARE Var_PregSecretaID			BIGINT(20);
	DECLARE Var_RespPregSecreta			VARCHAR(100);
	DECLARE Var_TelefonoFijo			VARCHAR(20);
	DECLARE Var_Control					VARCHAR(50);
	DECLARE Var_ImagenPhishingID		INT(11);
	DECLARE Var_Fecha					DATE;


	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Entero_Cero					INT(11);
	DECLARE Salida_Si					CHAR(1);
	DECLARE Salida_No					CHAR(1);
	DECLARE Decimal_Cero				DECIMAL(14,2);

	DECLARE Fecha_Vacia					DATE;
	DECLARE Var_PerFisica				CHAR(1);
	DECLARE Var_Clasif					CHAR(1);
	DECLARE Var_MotAper					CHAR(1);
	DECLARE Var_Isr						CHAR(1);

	DECLARE Var_Iva						CHAR(1);
	DECLARE Var_Ide						CHAR(1);
	DECLARE Var_Riesgo					CHAR(1);
	DECLARE Var_RegHacienNo				CHAR(1);
	DECLARE Var_ActInegi				INT(11);

	DECLARE Var_Nacional				CHAR(1);
	DECLARE Var_PromotorIni				INT(11);
	DECLARE Var_PromotorAct				INT(11);
	DECLARE Var_PEPs					CHAR(1);

	DECLARE Var_PaisResi				INT(11);
	DECLARE Var_SectorGral				INT(11);
	DECLARE Var_PaisNaci				INT(11);
	DECLARE Var_EstCivil				CHAR(1);
	DECLARE Var_SecEcon					INT(11);


	DECLARE Var_FuncionID				INT(11);
	DECLARE Var_ParentesPEP				CHAR(1);
	DECLARE Var_CoberGeog				CHAR(1);
	DECLARE Var_Importa					CHAR(1);
	DECLARE Var_SucursalOri				INT(11);

	DECLARE Var_Exporta					CHAR(1);
	DECLARE Var_Relacion1				INT(11);
	DECLARE Var_Relacion2				INT(11);
	DECLARE Var_Particip				DECIMAL(14,2);

	DECLARE Var_EsMenorEdad				CHAR(1);
	DECLARE Var_TipoDirecID				INT(11);

	DECLARE Var_Oficial					CHAR(1);


	DECLARE  Var_EvaluaXMatriz		CHAR(1);
	DECLARE  Var_ComentarioNivel	VARCHAR(200);
	DECLARE  Var_NoCuentaRefCom		VARCHAR(50);
	DECLARE  Var_NoCuentaRefCom2	VARCHAR(50);
	DECLARE  Var_DireccionRefCom	VARCHAR(500);
	DECLARE  Var_DireccionRefCom2	VARCHAR(500);
	DECLARE  Var_BanTipoCuentaRef	VARCHAR(50);
	DECLARE  Var_BanTipoCuentaRef2	VARCHAR(50);
	DECLARE  Var_BanSucursalRef		VARCHAR(50);
	DECLARE  Var_BanSucursalRef2	VARCHAR(50);
	DECLARE  Var_BanNoTarjetaRef	VARCHAR(50);
	DECLARE  Var_BanNoTarjetaRef2	VARCHAR(50);
	DECLARE  Var_BanTarjetaInsRef	VARCHAR(50);
	DECLARE  Var_BanTarjetaInsRef2	VARCHAR(50);
	DECLARE  Var_BanCredOtraEnt		CHAR(1);
	DECLARE  Var_BanCredOtraEnt2	CHAR(1);
	DECLARE  Var_BanInsOtraEnt		VARCHAR(50);
	DECLARE  Var_BanInsOtraEnt2		VARCHAR(50);


	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:=  0;
	SET Salida_Si				:= 'S';
	SET Salida_No				:= 'N';
	SET Decimal_Cero 			:=  0.00;
	SET Fecha_Vacia				:='1900-01-01';

	SET Var_EsMenorEdad			:= 'N';
	SET Var_PerFisica			:= 'F';
	SET Var_Clasif				:= 'E';
	SET Var_MotAper				:= '1';

	SET Var_Isr					:= 'S';
	SET Var_Iva					:= 'S';
	SET Var_Ide					:= 'S';
	SET Var_Riesgo				:= 'B';
	SET Var_RegHacienNo			:= 'N';
	SET Var_Nacional			:= 'N';

	SET Var_PromotorIni			:=  1;
	SET Var_PromotorAct			:=  1;
	SET Var_PEPs				:= 'N';
	SET Var_PaisResi			:= 700;
	SET Var_PaisNaci			:= 700;

	SET Var_SectorGral			:= 999;
	SET Var_EstCivil			:= 'S';
	SET Var_SecEcon				:= Entero_Cero;


	SET Var_FuncionID			:= 99;

	SET Var_ParentesPEP			:= 'N';
	SET Var_CoberGeog			:= 'L';
	SET Var_Importa				:= 'N';
	SET Var_SucursalOri 		:= 1;
	SET Var_Exporta				:= 'N';
	SET Var_Relacion1			:= 0;

	SET Var_Relacion2			:= 0;
	SET Var_Particip			:= 0.00;

	SET Var_TipoDirecID			:= 1;
	SET Var_Oficial				:= 'S';
	SET Var_ActInegi			:= 99999;


	SET Var_EvaluaXMatriz    := IFNULL(Var_EvaluaXMatriz,Salida_No);
	SET Var_ComentarioNivel    := IFNULL(Var_ComentarioNivel,Cadena_Vacia);
	SET Var_NoCuentaRefCom     := IFNULL(Var_NoCuentaRefCom,Cadena_Vacia);
	SET Var_NoCuentaRefCom2    := IFNULL(Var_NoCuentaRefCom2,Cadena_Vacia);
	SET Var_DireccionRefCom    := IFNULL(Var_DireccionRefCom,Cadena_Vacia);
	SET Var_DireccionRefCom2   := IFNULL(Var_DireccionRefCom2,Cadena_Vacia);
	SET Var_BanTipoCuentaRef   := IFNULL(Var_BanTipoCuentaRef,Cadena_Vacia);
	SET Var_BanTipoCuentaRef2  := IFNULL(Var_BanTipoCuentaRef2,Cadena_Vacia);
	SET Var_BanSucursalRef     := IFNULL(Var_BanSucursalRef,Cadena_Vacia);
	SET Var_BanSucursalRef2    := IFNULL(Var_BanSucursalRef2,Cadena_Vacia);
	SET Var_BanNoTarjetaRef    := IFNULL(Var_BanNoTarjetaRef,Cadena_Vacia);
	SET Var_BanNoTarjetaRef2   := IFNULL(Var_BanNoTarjetaRef2,Cadena_Vacia);
	SET Var_BanTarjetaInsRef   := IFNULL(Var_BanTarjetaInsRef,Cadena_Vacia);
	SET Var_BanTarjetaInsRef2  := IFNULL(Var_BanTarjetaInsRef2,Cadena_Vacia);
	SET Var_BanCredOtraEnt     := IFNULL(Var_BanCredOtraEnt,Cadena_Vacia);
	SET Var_BanCredOtraEnt2    := IFNULL(Var_BanCredOtraEnt2,Cadena_Vacia);
	SET Var_BanInsOtraEnt      := IFNULL(Var_BanInsOtraEnt,Cadena_Vacia);
	SET Var_BanInsOtraEnt2     := IFNULL(Var_BanInsOtraEnt2,Cadena_Vacia);


	SET Par_Telefono	:= IFNULL(Par_Telefono, Cadena_Vacia);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: BANALTACLIENTEPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		SET Par_ClienteID	:= 0;


		IF(Par_Telefono = Cadena_Vacia)THEN
			SET Par_NumErr      := 001;
			SET Par_ErrMen      := 'El telefono esta vacio.';
			SET Var_Control     := 'Par_Telefono';
			LEAVE ManejoErrores;
		END IF;

		SET Var_PrimerNombre             := IFNULL(Par_PrimerNombre, Cadena_Vacia);
		SET Var_SegundoNombre            := IFNULL(Par_SegundoNombre, Cadena_Vacia);
		SET Var_ApellidoPaterno          := IFNULL(Par_ApellidoPaterno, Cadena_Vacia);
		SET Var_ApellidoMaterno          := IFNULL(Par_ApellidoMaterno, Cadena_Vacia);
		SET Var_FechaNacimiento          := IFNULL(Par_FechaNacimiento, Fecha_Vacia);
		SET Var_LugarNacimientoID        := IFNULL(Par_EdoNacID, Entero_Cero);
		SET Var_EstadoID                 := IFNULL(Par_EstadoID, Entero_Cero);
		SET Var_MunicipioID              := IFNULL(Par_MunicipioID, Entero_Cero);
		SET Var_ColoniaID                := IFNULL(Par_ColoniaID, Entero_Cero);
		SET Var_LocalidadID              := IFNULL(Par_LocalidadID, Entero_Cero);
		SET Var_Calle                    := IFNULL(Par_Calle, Cadena_Vacia);
		SET Var_NoExterior               := IFNULL(Par_NoExterior, Cadena_Vacia);
		SET Var_CodigoPostal             := IFNULL(Par_CodPostal, Cadena_Vacia);
		SET Var_Genero                   := IFNULL(Par_Genero, Cadena_Vacia);
		SET Var_Curp                     := IFNULL(Par_Curp, Cadena_Vacia);
		SET Var_Rfc                      := IFNULL(Par_Rfc, Cadena_Vacia);
		SET Var_TelefonoFijo             := IFNULL(Par_TelefonoFijo, Cadena_Vacia);
		SET Var_Correo                   := IFNULL(Par_Correo, Cadena_Vacia);
		SET Var_OcupacionID              := IFNULL(Par_OcupacionID, Entero_Cero);
		SET Var_RespPregSecreta          := IFNULL(Par_RespPregSecreta, Cadena_Vacia);
		SET Var_PregSecretaID            := IFNULL(Par_PreguntaSecretaID, Entero_Cero);
		SET Var_Contrasenia              := IFNULL(Par_Contrasenia, Cadena_Vacia);
		SET Var_ImagenPhishingID         := IFNULL(Par_ImagenPhishingID, Entero_Cero);
		SET Var_ActBMX                   := IFNULL(Par_ActividadBMXID, Entero_Cero);

		SELECT	ActividadFR,		ActividadFOMUR
		  INTO	Var_ActividadFR,	Var_ActividadFOMUR
			FROM ACTIVIDADESBMX
			WHERE	ActividadBMXID = Var_ActBMX;


		SELECT	FechaSistema
		  INTO	Var_Fecha
			FROM PARAMETROSSIS;
		SET Var_Fecha	:= IFNULL(Var_Fecha, Fecha_Vacia);


		CALL CLIENTESALT(
			Var_SucursalOri, 	 Var_PerFisica,       	 Cadena_Vacia,        	 Var_PrimerNombre,    	 Var_SegundoNombre,
			Cadena_Vacia,    	 Var_ApellidoPaterno, 	 Var_ApellidoMaterno, 	 Var_FechaNacimiento, 	 Var_PaisNaci,
			Var_EstadoID,    	 Var_Nacional,        	 Var_PaisResi,        	 Var_Genero,          	 Var_Curp,
			Var_Rfc,         	 Var_EstCivil,        	 Par_Telefono,        	 Var_TelefonoFijo,    	 Var_Correo,
			Cadena_Vacia,    	 Entero_Cero,         	 Var_Rfc,             	 Entero_Cero,         	 Cadena_Vacia,
			Var_OcupacionID, 	 Cadena_Vacia,        	 Cadena_Vacia,        	 Entero_Cero,         	 Cadena_Vacia,
			Cadena_Vacia,    	 Var_Clasif,          	 Var_MotAper,         	 Var_Isr,             	 Var_Iva,
			Var_Ide,         	 Var_Riesgo,          	 Var_SectorGral,      	 Var_ActBMX,          	 Var_ActInegi,
			Var_SecEcon,     	 Var_ActividadFR,     	 Var_ActividadFOMUR,  	 Var_PromotorIni,     	 Var_PromotorAct,
			Entero_Cero,     	 Var_EsMenorEdad,     	 Entero_Cero,         	 Var_RegHacienNo,     	 Entero_Cero,
			Entero_Cero,     	 Cadena_Vacia,        	 Cadena_Vacia,        	 Cadena_Vacia,        	 Cadena_Vacia,
			Cadena_Vacia,    	 Entero_Cero,        	 Entero_Cero,        	 Entero_Cero,         	 Fecha_Vacia,
			Entero_Cero,     	 Cadena_Vacia,        	 Entero_Cero,         	 Fecha_Vacia,         	 Entero_Cero,
			Cadena_Vacia,    	 Cadena_Vacia,        	 Entero_Cero,         	 Cadena_Vacia,        	 Cadena_Vacia,
			Par_PaisNacional,    Par_EmpresaID,       	 Salida_No,           	 Par_NumErr,          	 Par_ErrMen,
			Par_ClienteID,   	 Aud_Usuario,         	 Aud_FechaActual,     	 Aud_DireccionIP,     	 Aud_ProgramaID,
			Aud_Sucursal,    	 Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		CALL DIRECCLIENTEALT(
			Par_ClienteID,   		 Var_TipoDirecID, 		 Var_EstadoID, 		 Var_MunicipioID,   		 Var_LocalidadID,
			Var_ColoniaID,   		 Cadena_Vacia,    		 Var_Calle,    		 Par_NoExterior,    		 Par_NoInterior,
			Cadena_Vacia,    		 Cadena_Vacia,    		 Cadena_Vacia, 		 Var_CodigoPostal,  		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,    		 Var_Oficial,  		 Cadena_Vacia,      		 Entero_Cero,
			Cadena_Vacia,    		 Cadena_Vacia,    		 Entero_Cero,  		 Entero_Cero,       		 Entero_Cero,
			Salida_No,       		 Par_NumErr,      		 Par_ErrMen,   		 Aud_Usuario,       		 Aud_FechaActual,
			Aud_DireccionIP, 		 Aud_ProgramaID,  		 Aud_Sucursal, 		 Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;


		CALL CONOCIMIENTOCTEALT(
			Par_ClienteID,   		 Cadena_Vacia,   		 Var_Rfc,       		 Var_Particip,       		 Var_Nacional,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Var_PEPs,      		 Var_FuncionID,      		 Var_ParentesPEP,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Var_CoberGeog,   		 Cadena_Vacia,   		 Decimal_Cero,  		 Decimal_Cero,       		 Decimal_Cero,
			Decimal_Cero,    		 Var_Importa,    		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Var_Exporta,    		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Var_Relacion1,  		 Var_Relacion2, 		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Decimal_Cero,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Cadena_Vacia,  		 Cadena_Vacia,       		 Cadena_Vacia,
			Cadena_Vacia,    		 Fecha_Vacia,    		 Cadena_Vacia,  		 Decimal_Cero,       		 Decimal_Cero,
			Cadena_Vacia,    		 Cadena_Vacia,   		 Entero_Cero,   		 Entero_Cero,        		 Salida_No,
			Par_NumErr,      		 Par_ErrMen,     		 Par_EmpresaID, 		 Aud_Usuario,        		 Aud_FechaActual,
			Aud_DireccionIP, 		 Aud_ProgramaID, 		 Aud_Sucursal,  		 Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr      := 000;
		SET Par_ErrMen      := 'El cliente se ha registrado correctamente.';
		SET Var_Control     := 'ClienteID';

	END ManejoErrores;


	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_ClienteID  AS consecutivo;
	END IF;


END TerminaStore$$
