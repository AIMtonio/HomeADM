-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOD`;
DELIMITER $$


CREATE PROCEDURE `CUENTASAHOMOD`(
	Par_CuentaAhoID			BIGINT(12),
	Par_SucursalID 			INT(11),
	Par_ClienteID 			INT(11),
	Par_Clabe 				VARCHAR(18),
	Par_MonedaID 			INT(11),
	Par_TipoCuentaID 		INT(11),
	Par_FechaReg 			DATE,
	Par_Etiqueta 			VARCHAR(50),
	Par_EdoCta 				CHAR(1),
	Par_InstitucionID 		INT(11),
	Par_EsPrincipal			CHAR(1),
	Par_TelefonoCelular     VARCHAR(20),

	Aud_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore:BEGIN

	-- declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Estatus_Registrada	CHAR(1);
	DECLARE Estatus_Activa 		CHAR(1);
	DECLARE	Var_Estatus			CHAR(1);
	DECLARE TipoBancaria 		CHAR(1);
	DECLARE Var_SI				CHAR(1);
	DECLARE Var_TipoPersona 	CHAR(1);
	DECLARE TipoCuentaNO    	CHAR(1);
	DECLARE Var_EsSocioMenor 	CHAR(1);		-- Indica si es Socio Menor
	DECLARE Per_MenorEdad     	CHAR(1);
	DECLARE VarEsMenorEdad    	CHAR(1);
	DECLARE Inactivo			CHAR(1);
	DECLARE Estatus_Cancelada   CHAR(1);
	-- declaracion de variables
	DECLARE var_Principal		CHAR(1); -- guarda el valor de si es una cuenta principal
	DECLARE var_CuentaAho		BIGINT(12); -- guarda el valor de la cuenta de ahorro consultada
	DECLARE Var_EstatusCli		CHAR(1);
	DECLARE Var_esBancaria      CHAR(1);-- Si el tipo de cuenta es  bancaria
     -- JQUINTAL NARRATIVA 0010 MEXI
	DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
	DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
	DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES
    DECLARE	Par_NumErr				INT(11);		-- Parametro INOUT para el Numero de Error
	DECLARE Par_ErrMen				VARCHAR(400);	-- Parametro INOUT para la Descripcion del Error
    DECLARE Var_Control				VARCHAR(50);		-- Variable de Control
	DECLARE Var_Consecutivo 	INT(12);			-- Variable Consecutivo
    DECLARE	Salida_No			char(1);
   	-- MMARTINEZ  MEXI
    DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
    DECLARE Var_RolA                INT(11);
    DECLARE Var_RolUsuario          INT(11);

	-- asignacion de constantes
	SET	Cadena_Vacia			:= '';			-- cadena o string vacio
	SET	Fecha_Vacia				:= '1900-01-01';-- fecha vacia
	SET	Entero_Cero				:= 0;			-- entero en cero
	SET	Estatus_Registrada		:= 'R';			-- indica estatus registrado
	SET	Estatus_Activa			:= 'A';			-- indica estatus Activa
	SET TipoBancaria 			:= 'S';			-- indica el valor de una  cuenta tipo bancaria
	SET Var_SI	 				:= 'S';			-- indica el valor para SI
	SET TipoCuentaNO      		:= 'N';
	SET Per_MenorEdad      		:= 'E';
	SET VarEsMenorEdad     		:= 'S';
	SET Inactivo				:= 'I';
	SET Estatus_Cancelada       := 'C';
      -- JQUINTAL NARRATIVA 0010 MEXI
	SET Cliente_Vigua_Serv_Pat:=38;
	SET Var_ParamCli			:='CliProcEspecifico';
    SET Par_NumErr				:=0;
    SET Par_ErrMen				:='';
    Set	Salida_No				:= 'N';		-- Salida No
   	-- MMARTINEZ  MEXI
    SET Var_RolPerf             :='RolActPerfil';



	SELECT Estatus INTO Var_EstatusCli
		FROM CLIENTES
			WHERE ClienteID=Par_ClienteID;

 -- JQuintal NARRATIVA 0010 MEXI
	SELECT ValorParametro
		INTO Var_CliEsp
		FROM PARAMGENERALES
			WHERE LlaveParametro = Var_ParamCli;

	SELECT ValorParametro
			INTO Var_RolA
			FROM PARAMGENERALES
				WHERE LlaveParametro = Var_RolPerf;

	 SELECT RolID INTO Var_RolUsuario FROM USUARIOS WHERE  UsuarioID = Aud_Usuario;

		SET Var_CliEsp:=IFNULL(Var_CliEsp,Entero_Cero);

        SET Var_RolUsuario:=IFNULL(Var_RolUsuario,Entero_Cero);


		IF (Var_CliEsp=Cliente_Vigua_Serv_Pat) THEN

            IF(Var_RolA != Var_RolUsuario)THEN

                CALL VALIDADATOSCTEVAL(
                        Par_ClienteID,			Salida_No,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
                        Aud_Usuario ,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                        Aud_NumTransaccion);

                        IF( Par_NumErr<>Entero_Cero) THEN
                            SELECT Par_NumErr AS NumErr,
                            Par_ErrMen  AS ErrMen,
                            'clienteID ' AS control,
                            Par_ClienteID AS consecutivo;
                            LEAVE TerminaStore;
                        END IF;
                END IF;
		END IF;

	IF(Var_EstatusCli=Inactivo)THEN
		SELECT '001' AS NumErr,
			'El Cliente se Encuentra Inactivo'  AS ErrMen,
			'clienteID ' AS control,
			Par_ClienteID AS consecutivo;
		LEAVE TerminaStore;
	END IF;

	IF(NOT EXISTS(SELECT CuentaAhoID
				FROM CUENTASAHO
				WHERE CuentaAhoID = Par_CuentaAhoID)) THEN
		SELECT '001' AS NumErr,
			 'La Cuenta no existe.' AS ErrMen,
			 'cuentaAhoID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_CuentaAhoID, Entero_Cero))= Entero_Cero THEN
		SELECT '002' AS NumErr,
			 'El numero de safilocale.ctaAhorro esta Vacio.' AS ErrMen,
			 'cuentaAhoID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_SucursalID, Entero_Cero))= Entero_Cero THEN
		SELECT '003' AS NumErr,
			 'El numero de Sucursal esta Vacio.' AS ErrMen,
			 'sucursalID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_ClienteID, Entero_Cero))= Entero_Cero THEN
		SELECT '004' AS NumErr,
			 'El numero de Cliente esta Vacio.' AS ErrMen,
			 'clienteID' AS control;
		LEAVE TerminaStore;
	END IF;


	IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
		SELECT '005' AS NumErr,
			 'La Moneda esta Vacia.' AS ErrMen,
			 'monedaID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_TipoCuentaID, Entero_Cero))= Entero_Cero THEN
		SELECT '006' AS NumErr,
			 'El Tipo de Cuenta esta Vacio.' AS ErrMen,
			 'tipoCuentaID' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_FechaReg,Fecha_Vacia)) = Fecha_Vacia THEN
		SELECT '008' AS NumErr,
			 'La Fecha esta Vacia.' AS ErrMen,
			 'fechaReg' AS control;
		LEAVE TerminaStore;
	END IF;

	IF(IFNULL(Par_Etiqueta,Cadena_Vacia)) = Cadena_Vacia THEN
		SELECT '007' AS NumErr,
			 'La Etiqueta esta Vacia.' AS ErrMen,
			 'etiqueta' AS control;
		LEAVE TerminaStore;
	END IF;


	SELECT esBancaria  INTO Var_esBancaria
	            FROM TIPOSCUENTAS
	            WHERE TipoCuentaID = Par_TipoCuentaID;

	IF( Var_esBancaria = TipoBancaria)THEN

	    IF(IFNULL(Par_Clabe,Cadena_Vacia))= Cadena_Vacia THEN
	             SELECT '006' AS NumErr,
	            'Especifique la Clabe.' AS ErrMen,
	            'Clabe' AS control;
	            LEAVE TerminaStore;

	      END IF;

	      IF(IFNULL(Par_InstitucionID,Entero_Cero))= Entero_Cero THEN
	             SELECT '006' AS NumErr,
	            'Especifique el Banco.' AS ErrMen,
	            'InstitucionID' AS control;
	            LEAVE TerminaStore;

	      END IF;

	END IF;

	IF(IFNULL(Par_EsPrincipal,Cadena_Vacia)) = Cadena_Vacia THEN
		SELECT '010' AS NumErr,
			 'Especifique si es Cuenta Principal' AS ErrMen,
			 'esPrincipal' AS control, NumCuentaAhoID AS consecutivo;
		LEAVE TerminaStore;
	ELSE
		-- si el valor para principal no llega vacio, se valida
		IF(IFNULL(Par_EsPrincipal,Cadena_Vacia)) = Var_SI THEN
			-- se busca si ya existia una cuenta principal
			SELECT EsPrincipal, CuentaAhoID
			INTO var_Principal, var_CuentaAho
			FROM CUENTASAHO
			WHERE ClienteID =Par_ClienteID AND EsPrincipal=Var_SI
			AND Estatus != Estatus_Cancelada;
			IF((IFNULL(var_Principal,Cadena_Vacia)) = Var_SI )THEN
				IF(var_CuentaAho <> Par_CuentaAhoID)THEN
					SELECT '013' AS NumErr,
						 'No puede tener dos cuentas Principal' AS ErrMen,
						 'esPrincipal' AS control, Par_CuentaAhoID AS consecutivo;
					LEAVE TerminaStore;
				END IF;
			END IF;
		END IF;
	END IF;

	SELECT EsMenorEdad INTO Var_EsSocioMenor
		FROM CLIENTES
			WHERE ClienteID=Par_ClienteID;

	    IF (Var_EsSocioMenor = VarEsMenorEdad ) THEN
	        SELECT
	        CASE WHEN cta.TipoPersona LIKE CONCAT('%',Per_MenorEdad,'%') AND cli.EsMenorEdad = VarEsMenorEdad  THEN 'S' ELSE 'N'
	            END AS Permite INTO Var_TipoPersona
	        FROM TIPOSCUENTAS cta, CLIENTES cli
	        WHERE cli.ClienteID = Par_ClienteID AND TipoCuentaID = Par_TipoCuentaID;
	    ELSE
	        SELECT
	            CASE WHEN cta.TipoPersona LIKE CONCAT('%', cli.TipoPersona,'%') THEN 'S' ELSE 'N'
	                END AS Permite INTO Var_TipoPersona
	        FROM TIPOSCUENTAS cta, CLIENTES cli
	        WHERE cli.ClienteID = Par_ClienteID AND TipoCuentaID = Par_TipoCuentaID;
	    END IF;

	    IF (Var_TipoPersona = TipoCuentaNO)THEN
	        SELECT '014' AS NumErr,
				CONCAT('El Tipo de Cuenta no esta permitido para la Personalidad del Cliente.' )AS ErrMen,
				'tipoCuentaID' AS control,
	          Par_TipoCuentaID AS consecutivo;
			LEAVE TerminaStore;
	    END IF;


	SET Var_Estatus := (SELECT Estatus FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);

	SET Aud_FechaActual := CURRENT_TIMESTAMP();


	-- UPDATE Solo para cuentas bancarias(NOSTRO)

	IF((Var_Estatus = Estatus_Registrada OR Var_Estatus = Estatus_Activa) AND Var_esBancaria = TipoBancaria) THEN
		UPDATE CUENTASAHO SET
			SucursalID    		= Par_SucursalID,
			ClienteID     		= Par_ClienteID,
			Clabe				= Par_Clabe,
			MonedaID       		= Par_MonedaID,
			FechaReg        	= Par_FechaReg,
			TipoCuentaID    	= Par_TipoCuentaID,
			Etiqueta	 		= Par_Etiqueta,
			EstadoCta			= Par_EdoCta,
			InstitucionID 		= Par_InstitucionID,
			EsPrincipal			= Par_EsPrincipal,
	        TelefonoCelular     = Par_TelefonoCelular,

			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE CuentaAhoID 		= Par_CuentaAhoID;


	-- UPDATE para cuentas que no son bancarias
	ELSEIF((Var_Estatus = Estatus_Registrada OR Var_Estatus = Estatus_Activa) AND Var_esBancaria != TipoBancaria) THEN
			UPDATE CUENTASAHO SET
			SucursalID    		= Par_SucursalID,
			ClienteID     		= Par_ClienteID,
			MonedaID       		= Par_MonedaID,
			FechaReg        	= Par_FechaReg,
			TipoCuentaID    	= Par_TipoCuentaID,
			Etiqueta	 		= Par_Etiqueta,
			EstadoCta			= Par_EdoCta,
			InstitucionID 		= Par_InstitucionID,
			EsPrincipal			= Par_EsPrincipal,
	        TelefonoCelular     = Par_TelefonoCelular,

			EmpresaID			= Aud_EmpresaID,
			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE CuentaAhoID 		= Par_CuentaAhoID;

	ELSE
		SELECT '010' AS NumErr,
			 'Solo se Pueden Modificar cuentas con estatus: Activa y Registrado.' AS ErrMen,
			 'cuentaAhoID' AS control;
		LEAVE TerminaStore;
	END IF;

	SELECT '000' AS NumErr ,
		  CONCAT('safilocale.ctaAhorro Modificada Exitosamente: ',CONVERT(Par_CuentaAhoID,CHAR)) AS ErrMen,
		  'cuentaAhoID' AS control;

END TerminaStore$$
