-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASTRANSFERACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASTRANSFERACT`;
DELIMITER $$


CREATE PROCEDURE `CUENTASTRANSFERACT`(
	Par_ClienteID		INT(11),
	Par_CuentaTranID	INT(11),
	Par_UsuarioAutoriza	INT(11),
	Par_FechaAutoriza	DATE,
	Par_UsuarioBaja		INT(11),
	Par_FechaBaja		DATE,
	Par_NumAct			TINYINT UNSIGNED,

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT,
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11) ,
	Aud_Usuario			INT(11) ,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11) ,
	Aud_NumTransaccion	BIGINT(20)
	)

TerminaStore:BEGIN

-- Declaracion de constantes
DECLARE Cadena_Vacia      	CHAR(1);
DECLARE Entero_Cero        	INT;
DECLARE Fecha_Vacia         DATE;
DECLARE Act_Baja			INT;
DECLARE Est_Baja			CHAR;
DECLARE Act_Auto			INT;
DECLARE Est_Auto			CHAR;
DECLARE SalidaSI			CHAR(1);
DECLARE SalidaNO			CHAR(1);
DECLARE	FechaActual	       DATE;
DECLARE Act_EstDomicilia	INT(11);
DECLARE Est_NoAfiliado		CHAR(1);
 -- JQUINTAL NARRATIVA 0010 MEXI
	DECLARE Cliente_Vigua_Serv_Pat 	INT(11); 		-- CLIENTE VIGUA SERVICIOS PATRIMONIALES
	DECLARE Var_CliEsp  			INT (11);		-- CLIENTE ESPECIFICO
	DECLARE Var_ParamCli			VARCHAR(50);	-- PARAMETRO PARA BUSCAR CLIENTE ESPECIFICO EN PARAMGENERALES

	-- MMARTINEZ  MEXI
    DECLARE Var_RolPerf             VARCHAR(50);        -- PARAMETRO PARA VALIDAR ROL
    DECLARE Var_RolA                INT(11);
    DECLARE Var_RolUsuario          INT(11);

-- Declaracion de variables

-- Asignacion de constantes
SET Cadena_Vacia			:= '';				-- cadena vacia
SET Fecha_Vacia    			:= '1900-01-01';	-- fecha vacia
SET Entero_Cero        		:= 0;				-- entero cero
SET	Act_Baja				:= 1;				-- tipo de actualizacion para baja de cuenta
SET	Est_Baja				:= 'B';				-- corresponde con el estatus de baja
SET	Act_Auto				:= 2;				-- tipo de actualizacion para baja de cuenta
SET	Est_Auto				:= 'A';				-- corresponde con el estatus de baja
SET SalidaSI				:='S';				-- Salida Si
SET SalidaNO				:='N';				-- Salida NO
SET FechaActual		           := (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID=1);
SET Act_EstDomicilia		:= 3;				-- Actualiza estatus para domicila
SET Est_NoAfiliado			:= 'N';
-- JQUINTAL NARRATIVA 0010 MEXI
SET Cliente_Vigua_Serv_Pat:=38;
SET Var_ParamCli			:='CliProcEspecifico';
-- MMARTINEZ  MEXI
SET Var_RolPerf             :='RolActPerfil';


SET Aud_FechaActual			:= NOW();
-- Actualiza el estatus a Baja
IF(Par_NumAct = Act_Baja )THEN


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
                        Par_ClienteID,			SalidaNO,			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
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

	UPDATE CUENTASTRANSFER SET
		UsuarioBaja 	= Aud_Usuario,
		FechaBaja		= FechaActual,
		Estatus 		= Est_Baja,
		EstatusDomici 	= Est_Baja,
		EmpresaID		= Par_EmpresaID,

		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion
	WHERE ClienteID	= Par_ClienteID
	AND CuentaTranID =Par_CuentaTranID;

	IF(Par_Salida =SalidaSI) THEN
		SELECT '000' AS NumErr,
			CONCAT("Cuenta Destino Cancelada: ", CONVERT(Par_CuentaTranID, CHAR))  AS ErrMen,
			'cuentaTranID' 	AS control,
			Par_CuentaTranID AS consecutivo;
	END IF;
	IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 0;
			SET	Par_ErrMen := CONCAT("Cuenta Destino Cancelada: ", CONVERT(Par_CuentaTranID, CHAR));
	END IF;

END IF;

-- Actualiza el estatus a Autorizada
IF(Par_NumAct = Act_Auto )THEN
	UPDATE CUENTASTRANSFER SET
		UsuarioAutoriza = Par_UsuarioAutoriza,
		FechaAutoriza	= Par_FechaAutoriza,
		Estatus 		= Est_Auto,
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

		WHERE ClienteID	= Par_ClienteID
	AND CuentaTranID =Par_CuentaTranID;
END IF;



IF(Par_NumAct = Act_EstDomicilia )THEN
	UPDATE CUENTASTRANSFER SET
		UsuarioAutoriza = Par_UsuarioAutoriza,
		FechaAutoriza	= Par_FechaAutoriza,
		EstatusDomici 	= Est_NoAfiliado,
		EmpresaID		= Par_EmpresaID,
		Usuario			= Aud_Usuario,
		FechaActual 	= Aud_FechaActual,
		DireccionIP 	= Aud_DireccionIP,
		ProgramaID  	= Aud_ProgramaID,
		Sucursal		= Aud_Sucursal,
		NumTransaccion	= Aud_NumTransaccion

	WHERE ClienteID	= Par_ClienteID
	AND CuentaTranID =Par_CuentaTranID;

    IF(Par_Salida =SalidaSI) THEN
		SELECT '000' AS NumErr,
			CONCAT("Estatus de Domiciliación Modificada: ", CONVERT(Par_CuentaTranID, CHAR))  AS ErrMen,
			'cuentaTranID' 	AS control,
			Par_CuentaTranID AS consecutivo;
	END IF;
	IF(Par_Salida =SalidaNO) THEN
			SET Par_NumErr := 0;
			SET	Par_ErrMen := CONCAT("Estatus de Domiciliación Modificada: ", CONVERT(Par_CuentaTranID, CHAR));
	END IF;
END IF;

END TerminaStore$$
