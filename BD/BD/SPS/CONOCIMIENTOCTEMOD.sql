-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTEMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTEMOD`;
DELIMITER $$

CREATE PROCEDURE `CONOCIMIENTOCTEMOD`(
	/*SP para la modificacion del conocimiento del cliente*/
	Par_ClienteID		INT,
	Par_NomGrupo		VARCHAR(100),
	Par_RFC				VARCHAR(13),
	Par_Particip		DECIMAL(14,2),
	Par_Nacional		VARCHAR(45),

	Par_RazonSocial		VARCHAR(100),
	Par_Giro			VARCHAR(100),
	Par_PEPs			CHAR(1),
	Par_FuncionID		INT,
	Par_ParentesPEP		CHAR(1),

	Par_NombFam			VARCHAR(50),
	Par_aPaternoFam		VARCHAR(50),
	Par_aMaternoFam		VARCHAR(50),
	Par_NoEmpleados		CHAR(10),
	Par_Serv_Produc		VARCHAR(50),

	Par_Cober_Geog		CHAR(1),
	Par_Edos_Presen		VARCHAR(45),
	Par_ImporteVta		DECIMAL(14,2),
	Par_Activos			DECIMAL(14,2),
	Par_Pasivos			DECIMAL(14,2),

	Par_Capital			DECIMAL(14,2),
	Par_Importa			CHAR(1),
	Par_DolImport		CHAR(5),
	Par_PaisImport		VARCHAR(50),
	Par_PaisImport2		VARCHAR(50),

	Par_PaisImport3   	VARCHAR(50),
	Par_Exporta     	CHAR(1),
	Par_DolExport   	CHAR(5),
	Par_PaisExport    	VARCHAR(50),
	Par_PaisExport2   	VARCHAR(50),

	Par_PaisExport3   	VARCHAR(50),
	Par_NombRefCom    	VARCHAR(50),
	Par_NombRefCom2   	VARCHAR(50),
	Par_TelRefCom   	VARCHAR(20),
	Par_TelRefCom2    	VARCHAR(20),

	Par_BancoRef    	VARCHAR(45),
	Par_BancoRef2   	VARCHAR(45),
	Par_NoCtaRef    	VARCHAR(30),
	Par_NoCtaRef2   	VARCHAR(30),
	Par_NombreRef   	VARCHAR(50),

	Par_NombreRef2    	VARCHAR(50),
	Par_DomRef      	VARCHAR(150),
	Par_DomRef2     	VARCHAR(150),
	Par_TelRef      	VARCHAR(20),
	Par_TelRef2     	VARCHAR(20),

	Par_pFteIng     	VARCHAR(100),
	Par_IngAproxMes   	VARCHAR(10),
	Par_ExtTelRef1    	VARCHAR(6),
	Par_ExtTelRef2    	VARCHAR(6),
	Par_ExtTelRefCom  	VARCHAR(6),

	Par_ExtTelRefCom2 	VARCHAR(6),
	Par_Relacion1   	INT,
	Par_Relacion2   	INT,
	Par_PregUno     	VARCHAR(100),
	Par_RespUno     	VARCHAR(200),

	Par_PregDos     	VARCHAR(100),
	Par_RespDos     	VARCHAR(200),
	Par_PregTres    	VARCHAR(100),
	Par_RespTres    	VARCHAR(200),
	Par_PregCuatro    	VARCHAR(100),

	Par_RespCuatro    	VARCHAR(200),
	Par_CapitalContable DECIMAL(14,2),
	Par_NivelRiesgo		CHAR(1),
	Par_EvaluaXMatriz	CHAR(1),
	Par_ComentarioNivel	VARCHAR(200),

	Par_NoCuentaRefCom		VARCHAR(50),		-- Numero de cuenta de la referencia comercial
	Par_NoCuentaRefCom2		VARCHAR(50),		-- Numero de cuenta de la segunda referencia comercial
	Par_DireccionRefCom		VARCHAR(500),		-- Direccion de la referencia comercial
	Par_DireccionRefCom2	VARCHAR(500),		-- Direccion de la segunda referencia comercial
	Par_BanTipoCuentaRef	VARCHAR(50),		-- Tipo de cuenta de la referencia comercial bancaria

	Par_BanTipoCuentaRef2	VARCHAR(50),		-- Tipo de cuenta de la segunda referencia comercial bancaria
	Par_BanSucursalRef		VARCHAR(50),		-- Sucursal de la referencia comercial bancaria
	Par_BanSucursalRef2		VARCHAR(50),		-- Sucursal de la segunda referencia comercial bancaria
	Par_BanNoTarjetaRef		VARCHAR(50),		-- Numero de tarjeta de la referencia comercial bancaria
	Par_BanNoTarjetaRef2	VARCHAR(50),		-- Numero de tarjeta de la segunda referencia comercial bancaria

	Par_BanTarjetaInsRef	VARCHAR(50),		-- Institucion de la tarjeta de la referencia comercial bancaria
	Par_BanTarjetaInsRef2	VARCHAR(50),		-- Institucion de la tarjeta de la segunda referencia comercial bancaria
	Par_BanCredOtraEnt		CHAR(1),			-- Indica si la referencia comercial bancaria tiene o no un credito con otra entidad
	Par_BanCredOtraEnt2		CHAR(1),			-- Indica si la segunda referencia comercial bancaria tiene o no un credito con otra entidad
	Par_BanInsOtraEnt		VARCHAR(50),		-- Institucion con la que la referencia comercial bancaria tiene otro credito

	Par_BanInsOtraEnt2		VARCHAR(50),		-- Institucion con la que la segunda referencia comercial bancaria tiene otro credito
	Par_FechaNombramiento	DATE,				-- Fecha de Nombramiento en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_PeriodoCargo		VARCHAR(100),		-- Periodo del cargo en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_PorcentajeAcciones	DECIMAL(10,2),		-- Porcentaje de Acciones en caso de PEPs > Parametro para Cuestionarios Adicionales
	Par_MontoAcciones		DECIMAL(12,2),		-- Monto de las acciones en caso de PEPs > Parametro para Cuestionarios Adicionales

	Par_TiposClientes			CHAR(1),		-- Tipos de Clientes F) Persona Fisica M) Persona Moral > Parametro para Cuestionarios Adicionales.
	Par_InstrumentosMonetarios CHAR(1),			-- Instrumentos monetarios E) Efectivo C) Cheque T) > Transferencia\nParametro para Cuestionarios Adicionales.
	Par_OperacionAnios			INT(11),		-- Indica los años de la operacion de cliente
	Par_GiroAnios				INT(11),		-- Indica los años del giro de la operacion del cliente
	Par_Salida          		CHAR(1),		-- SI o NO Saldia

	INOUT Par_NumErr  		INT(11),			-- Numero de Error
	INOUT Par_ErrMen  		VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID   		INT,				-- Parametro de Auditoria
	Aud_Usuario     		INT,				-- Parametro de Auditoria
	Aud_FechaActual  		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP   		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID   		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal    		INT,				-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT				-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE ActNivelAlto			INT;
	DECLARE ActNivelBajo			INT;
	DECLARE Alta_ConocimientoCTE	INT(11);				# Alta Conocimiento del Cliente
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_Si					CHAR(1);				# Constante Si
	DECLARE Doble_Cero				INT;
	DECLARE Entero_Cero				INT;
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE FisicaActEmp			CHAR(1);
	DECLARE MenorEdad				CHAR(1);
	DECLARE Moral					CHAR(1);
	DECLARE NacionExt				CHAR(1);
	DECLARE NacionMex				CHAR(1);
	DECLARE NivelBajo				CHAR(1);
	DECLARE No_Exporta				CHAR(1);
	DECLARE No_Importa				CHAR(1);
	DECLARE PEP_No					CHAR(1);
	DECLARE PEP_Si					CHAR(1);
	DECLARE SalidaNO				CHAR(1);
	DECLARE SalidaSI				CHAR(1);
	DECLARE Var_ActividadBancoMX	VARCHAR(15);
	DECLARE Var_Control				VARCHAR(50);
	DECLARE Var_NacionCte			CHAR(1);
	DECLARE Var_NivelClaveRiesgo	CHAR(1);
	DECLARE Var_NumActualizacion	INT;
	DECLARE Var_TipoPersona			CHAR(1);
	DECLARE Var_NivelRiesgo			CHAR(1);
	DECLARE Var_FechaActual			DATE;
	DECLARE Var_ClienteCteID		INT(11);			-- Variable para Guardar el conocimiento de Cte.

	-- Asignacion de constantes
	SET ActNivelAlto				:= 8;				# Tipo de Actualizacion para el Nivel de Riesgo a ALTO
	SET ActNivelBajo				:= 9;				# Tipo de Actualizacion para el Nivel de Riesgo a BAJO
	SET Alta_ConocimientoCTE		:= 3;				# Alta Conocimiento del Cliente
	SET Cadena_Vacia				:= '';				# Cadena o String Vacio
	SET Cons_Si						:= 'S';				# Constante SI
	SET Doble_Cero					:= 0.0;				# DECIMAL Cero
	SET Entero_Cero					:= 0;				# Entero en Cero
	SET Estatus_Activo				:= 'A';				# Estatus Activo del conocimiento del cliente
	SET Fecha_Vacia					:= '1900-01-01';	# Fecha Vacia
	SET FisicaActEmp				:= 'A';				# persona fisica con actividad empresarial
	SET MenorEdad					:= 'S';				# Si es Menor de Edad
	SET Moral						:= 'M';				# El cliente es persona Moral
	SET NacionExt					:= 'E';				# Nacionalidad Extranjera
	SET NacionMex					:= 'N';				# Nacionalidad Mexicana (Nacional)
	SET NivelBajo					:='B';				# Nivel de Riesgo BAJO
	SET No_Exporta					:='N';
	SET No_Importa					:='N';
	SET Par_ErrMen					:= '';				# Mensaje de error para llamadas CALL (Eliminar si se recibe de parametro de entrada)
	SET Par_NumErr					:= 0;				# Numero de error para llamadas CALL (Eliminar si se recibe de parametro de entrada)
	SET PEP_No						:= 'N';				# No es PEP
	SET PEP_Si						:= 'S';				# Si es PEP
	SET SalidaNO					:= 'N';				# Salida No
	SET SalidaSI					:= 'S';				# Salida Si

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  'Disculpe las molestias que esto le ocasiona. Ref: SP-CONOCIMIENTOCTEMOD');
		END;

		SELECT ClienteID
			INTO Var_ClienteCteID
			FROM CONOCIMIENTOCTE
			WHERE ClienteID = Par_ClienteID;

		IF(IFNULL(Var_ClienteCteID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Cliente no Tiene Registro de Conocimiento de Cte a Modificar.';
			SET Var_Control := 'clienteCteID';
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT ClienteID
			  FROM CLIENTES
			  WHERE ClienteID = Par_ClienteID)) THEN
				SET Par_NumErr := 2;
		  SET Par_ErrMen := CONCAT('El Numero de ',FNSAFILOCALECTE(),' no existe.');
				SET Var_Control := 'clienteID';
		  LEAVE ManejoErrores;
		END IF;

		IF EXISTS (SELECT ClienteID
			  FROM CLIENTES
			  WHERE ClienteID = Par_ClienteID
			  AND EsMenorEdad = MenorEdad)THEN
						SET Par_NumErr := 10;
			  SET Par_ErrMen := CONCAT('El ',FNSAFILOCALECTE(),' es Menor de Edad.');
			  SET Var_Control := 'clienteID';
			  LEAVE ManejoErrores;
		END IF;

		IF (Par_Relacion1 != Cadena_Vacia)THEN
		IF(NOT EXISTS(SELECT TipoRelacionID
			   FROM TIPORELACIONES
			  WHERE TipoRelacionID = Par_Relacion1)) THEN
			SET Par_NumErr := 11;
			SET Par_ErrMen := 'El tipo de relacion no existe.';
			SET Var_Control := 'tipoRelacion1';
			LEAVE ManejoErrores;
		  END IF;
		END IF;

		IF (Par_Relacion2 != Cadena_Vacia)THEN
		IF(NOT EXISTS(SELECT TipoRelacionID
			   FROM TIPORELACIONES
			  WHERE TipoRelacionID = Par_Relacion2)) THEN
			SET Par_NumErr := 12;
			SET Par_ErrMen := 'El tipo de relacion no existe.';
			SET Var_Control := 'tipoRelacion2';
			LEAVE ManejoErrores;
		  END IF;
		END IF;

		-- asignacion para tipo de persona y nacionalidad
		SELECT TipoPersona,   Nacion,     ActividadBancoMX
		INTO Var_TipoPersona,   Var_NacionCte,  Var_ActividadBancoMX
		  FROM CLIENTES
		  WHERE ClienteID = Par_ClienteID;

		SELECT ClaveRiesgo INTO Var_NivelClaveRiesgo
		  FROM ACTIVIDADESBMX
			WHERE ActividadBMXID=Var_ActividadBancoMX;


		-- Si el Cliente es Extranjero y es PEP se concidera como de Nivel de Alto Riesgo
		IF(Var_NacionCte=NacionExt AND Par_PEPs=PEP_Si) THEN
		  SET Var_NumActualizacion := ActNivelAlto;
		END IF;

		IF(IFNULL(Var_NivelClaveRiesgo,NivelBajo)=NivelBajo AND Par_PEPs=PEP_No)THEN
		  SET Var_NumActualizacion := ActNivelBajo;
		END IF;

		SET Var_NumActualizacion := IFNULL(Var_NumActualizacion,ActNivelBajo);


		CALL CLIENTESACT(
		  Par_ClienteID,      Cadena_Vacia,   Cadena_Vacia,   Cadena_Vacia, Entero_Cero,
		  Cadena_Vacia,   Entero_Cero,      Cadena_Vacia,   Cadena_Vacia, Var_NumActualizacion,
		  SalidaNO,     Par_NumErr,     Par_ErrMen,   Aud_EmpresaID,  Aud_Usuario,
		  Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

		IF(Par_ErrMen!=Entero_Cero)THEN
				SET Par_NumErr := 13;
		  SET Par_ErrMen := 'Error en la actualizacion del Nivel de Riesgo.';
		  SET Var_Control := 'clienteID';
		  LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		  IF(Par_Importa = No_Importa)THEN
			SET Par_DolImport := Cadena_Vacia;
		  END IF;

		  IF(Par_Exporta = No_Exporta)THEN
			SET Par_DolExport := Cadena_Vacia;
		  END IF;

	IF(Par_OperacionAnios < Entero_Cero) THEN
			SET Par_NumErr := 20;
		 	SET Par_ErrMen := 'Años de Operacion debe ser Mayor o Igual a Cero.';
		 	SET Var_Control := 'operacionAnios';
		 	LEAVE ManejoErrores;
		END IF;

		IF(Par_GiroAnios < Entero_Cero) THEN
				SET Par_NumErr := 21;
				SET Par_ErrMen := 'Años de Giro debe ser Mayor o Igual a Cero.';
				SET Var_Control := 'giroAnios';
				LEAVE ManejoErrores;
	END IF;

	SELECT
		NivelRiesgo INTO Var_NivelRiesgo
		FROM CLIENTES
		WHERE
		ClienteID = Par_ClienteID;

		IF(IFNULL(Par_NivelRiesgo,'')=Cadena_Vacia) THEN
			SET Par_NivelRiesgo = Var_NivelRiesgo;
		END IF;


		SET Aud_FechaActual := NOW();


		UPDATE CONOCIMIENTOCTE SET
		  NomGrupo      			= Par_NomGrupo,
		  RFC         				= Par_RFC,
		  Participacion   			= Par_Particip,
		  Nacionalidad    			= Par_Nacional,
		  RazonSocial     			= Par_RazonSocial,

		  Giro        				= Par_Giro,
		  PEPs        				= Par_PEPs,
		  FuncionID     			= Par_FuncionID,
		  ParentescoPEP     		= Par_ParentesPEP,
		  NombFamiliar    			= Par_NombFam,

		  APaternoFam     			= Par_aPaternoFam,
		  AMaternoFam     			= Par_aMaternoFam,
		  NoEmpleados    			= Par_NoEmpleados,
		  Serv_Produc     			= Par_Serv_Produc,
		  Cober_Geograf   			= Par_Cober_Geog,

		  Estados_Presen    		= Par_Edos_Presen,
		  ImporteVta      			= Par_ImporteVta,
		  Activos       			= Par_Activos,
		  Pasivos       			= Par_Pasivos,
		  Capital       			= Par_Capital,

		  Importa       			= Par_Importa,
		  DolaresImport  			= Par_DolImport,
		  PaisesImport    			= Par_PaisImport,
		  PaisesImport2     		= Par_PaisImport2,
		  PaisesImport3     		= Par_PaisImport3,

		  Exporta       			= Par_Exporta,
		  DolaresExport   			= Par_DolExport,
		  PaisesExport    			= Par_PaisExport,
		  PaisesExport2   			= Par_PaisExport2,
		  PaisesExport3   			= Par_PaisExport3,

		  NombRefCom      			= Par_NombRefCom,
		  NombRefCom2    			= Par_NombRefCom2,
		  TelRefCom     			= Par_TelRefCom,
		  TelRefCom2      			= Par_TelRefCom2,
		  BancoRef      			= Par_BancoRef,

		  BancoRef2     			= Par_BancoRef2,
		  NoCuentaRef     			= Par_NoCtaRef,
		  NoCuentaRef2    			= Par_NoCtaRef2,
		  NombreRef       			= Par_NombreRef,
		  NombreRef2      			= Par_NombreRef2,

		  DomicilioRef    			= Par_DomRef,
		  DomicilioRef2  			= Par_DomRef2,
		  TelefonoRef       		= Par_TelRef,
		  TelefonoRef2    			= Par_TelRef2,
		  PFuenteIng      			= Par_pFteIng,

		  IngAproxMes     			= Par_IngAproxMes,
		  ExtTelefonoRefUno 		= Par_ExtTelRef1,
		  ExtTelefonoRefDos			= Par_ExtTelRef2,
		  EmpresaID     			= Aud_EmpresaID,
		  ExtTelRefCom    			= Par_ExtTelRefCom,

		  ExtTelRefCom2   			= Par_ExtTelRefCom2,
		  TipoRelacion1   			= Par_Relacion1,
		  TipoRelacion2   			= Par_Relacion2,
		  PreguntaCte1    			= Par_PregUno,
		  RespuestaCte1   			= Par_RespUno,

		  PreguntaCte2   			= Par_PregDos,
		  RespuestaCte2   			= Par_RespDos,
		  PreguntaCte3    			= Par_PregTres,
		  RespuestaCte3   			= Par_RespTres,
		  PreguntaCte4    			= Par_PregCuatro,

		  RespuestaCte4				= Par_RespCuatro,
		  CapitalContable			= Par_CapitalContable,
		  NoCuentaRefCom			= Par_NoCuentaRefCom,

		  NoCuentaRefCom2			= Par_NoCuentaRefCom2,
		  DireccionRefCom			= Par_DireccionRefCom,
		  DireccionRefCom2			= Par_DireccionRefCom2,
		  BanTipoCuentaRef			= Par_BanTipoCuentaRef,
		  BanTipoCuentaRef2			= Par_BanTipoCuentaRef2,

		  BanSucursalRef			= Par_BanSucursalRef,
		  BanSucursalRef2			= Par_BanSucursalRef2,
		  BanNoTarjetaRef			= Par_BanNoTarjetaRef,
		  BanNoTarjetaRef2			= Par_BanNoTarjetaRef2,
		  BanTarjetaInsRef			= Par_BanTarjetaInsRef,

		  BanTarjetaInsRef2			= Par_BanTarjetaInsRef2,
		  BanCredOtraEnt			= Par_BanCredOtraEnt,
		  BanCredOtraEnt2			= Par_BanCredOtraEnt2,
		  BanInsOtraEnt				= Par_BanInsOtraEnt,
		  BanInsOtraEnt2			= Par_BanInsOtraEnt2,

		  FechaNombramiento 		= Par_FechaNombramiento,
		  PeriodoCargo 				= Par_PeriodoCargo,
		  PorcentajeAcciones 		= Par_PorcentajeAcciones,
		  MontoAcciones 			= Par_MontoAcciones,
		  TiposClientes 			= Par_TiposClientes,

		  InstrumentosMonetarios 	= Par_InstrumentosMonetarios,
		  OperacionAnios 			= Par_OperacionAnios,
		  GiroAnios					= Par_GiroAnios,

		  Usuario					= Aud_Usuario,
		  FechaActual				= Aud_FechaActual,
		  DireccionIP				= Aud_DireccionIP,
		  ProgramaID				= Aud_ProgramaID,

		  Sucursal      			= Aud_Sucursal,
		  NumTransaccion    		= Aud_NumTransaccion

		WHERE ClienteID     		= Par_ClienteID;

		SET Par_EvaluaXMatriz := IFNULL(Par_EvaluaXMatriz,'S');
		SET Par_EvaluaXMatriz := IF(Par_EvaluaXMatriz = '','S',Par_EvaluaXMatriz);
		/*SI EL OC ES EL QUE ESTA HACIENDO EL CAMBIO ENTONCES SE ACTUALIZAN LOS DATOS*/
		IF EXISTS(SELECT OficialCumID FROM PARAMETROSSIS AS PAR WHERE PAR.OficialCumID = Aud_Usuario) THEN
			UPDATE CONOCIMIENTOCTE SET
				EvaluaXMatriz		= Par_EvaluaXMatriz,
				ComentarioNivel		= Par_ComentarioNivel,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE ClienteID			= Par_ClienteID;

			UPDATE CLIENTES SET
				NivelRiesgo		= Par_NivelRiesgo,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
				WHERE
				ClienteID = Par_ClienteID;
		END IF;

		IF(Par_EvaluaXMatriz = Cons_Si) THEN
		CALL RIESGOPLDCTEPRO(
			Par_ClienteID,			SalidaNO,				Par_NumErr,				Par_ErrMen,				Aud_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	  ELSE
	  	IF(Par_NivelRiesgo != Var_NivelRiesgo) THEN
	  		SET Var_FechaActual := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
			INSERT INTO PLDHISNIVELRIESGOXCLIENTE(
				ClienteID,					Fecha,						Hora,						FolioMatrizID,					NivelRiesgoObt,
				TotalPonderado,				TipoProceso,				EmpresaID,					Usuario,						FechaActual,
				DireccionIP,				ProgramaID,					Sucursal,					NumTransaccion)
			  SELECT
				Par_ClienteID,				Var_FechaActual,			CURRENT_TIME(),				NULL,							Par_NivelRiesgo,
				0,							'M',						Aud_EmpresaID,				Aud_Usuario,					Aud_FechaActual,
				Aud_DireccionIP,			Aud_ProgramaID,				Aud_Sucursal,				Aud_NumTransaccion;
			END IF;
	 END IF;

		/*Se almacena la Informacion en la Bitacora Historica. ############################################################################ */
		CALL BITACORAHISTPERSALT(
			Aud_NumTransaccion,		Alta_ConocimientoCTE,		Par_ClienteID,		Entero_Cero,		Entero_Cero,
			Entero_Cero,			SalidaNO,					Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr!=Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
		/*FIN de Respaldo de Bitacora Historica ########################################################################################### */
		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Conocimiento del ',FNSAFILOCALECTE(),' Modificado Exitosamente: ',Par_ClienteID);
		SET Var_Control := 'clienteID';

	END ManejoErrores;

	IF Par_Salida = SalidaSI THEN
	  SELECT Par_NumErr AS NumErr,
		   Par_ErrMen  AS ErrMen,
		   Var_Control AS Control;
	END IF;

END TerminaStore$$
