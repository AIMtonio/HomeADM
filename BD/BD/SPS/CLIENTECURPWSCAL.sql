-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTECURPWSCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTECURPWSCAL`;DELIMITER $$

CREATE PROCEDURE `CLIENTECURPWSCAL`(
/* SP PARA LA GENERACION DE LA CURP */
	Par_PrimerNombre					VARCHAR(50),		-- Primer nombre
	Par_SegundoNombre					VARCHAR(50),		-- Segundo nombre
	Par_TercerNombre					VARCHAR(50),		-- Tercer nombre
	Par_ApellidoPat						VARCHAR(50),		-- Apellido paterno
	Par_ApellidoMat						VARCHAR(50),		-- Apellido materno

	Par_Genero							CHAR(1),			-- H = Hombre(Masculino)	M = Mujer(Femenino)
	Par_FecNac							DATE,				-- Fecha de nacimiento
	Par_Nacionalidad					CHAR(1),			-- N.Nacional  E. Extranjero
	Par_EntidadFed						INT(11),			-- Entidad federativa
    Par_Usuario							VARCHAR(20),		-- Usuario

    Par_Clave							VARCHAR(100),		-- Clave de Usuario
	INOUT  Par_CURP						VARCHAR(18),		-- CURP generada
	Par_Salida							CHAR(1),			-- Salida S: Si N:No
	INOUT  Par_NumErr					INT(11),			-- Numero de error
	INOUT  Par_ErrMen					VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID						INT,				-- AUDITORIA
	Aud_Usuario							INT,				-- AUDITORIA
	Aud_FechaActual						DATETIME,			-- AUDITORIA
	Aud_DireccionIP						VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID						VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal						INT,				-- AUDITORIA
	Aud_NumTransaccion					BIGINT				-- AUDITORIA
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_LetrasRFC				VARCHAR(4);				-- Letras de RFC
	DECLARE Var_FechaNacimiento			VARCHAR(6);				-- Fecha de nacimiento
	DECLARE Var_Entidad					CHAR(2);				-- Entidad federativa
	DECLARE Var_Consonantes				VARCHAR(3);				-- Consonantes
	DECLARE Var_CaracterProgresivo		CHAR(1);
	DECLARE Var_DigitoVerificador		CHAR(1);				-- Digito verificador
	DECLARE Var_NombreConsonante		VARCHAR(40);			-- Nombre para sacar la consonante
	DECLARE Var_PosicionCiclo			INT(11);				-- Numero de ciclo
	DECLARE Var_Letra					CHAR(1);				-- Letra
	DECLARE Var_LetraAux				CHAR(1);				-- Letra auxiliar
	DECLARE Var_ValorPosicion			INT(11);				-- Valor posicion
	DECLARE Var_ResiduoBase10			INT(11);				-- Residuo base 10 para sacar el digito verificador
	DECLARE Var_CURP					VARCHAR(18);			-- CURP formada
	DECLARE Var_Caracter				CHAR(1);				-- Caracter
	DECLARE Var_ValorCaracter			INT(11);				-- Valor de caracter
	DECLARE Var_ApePat					VARCHAR(50);			-- Apellido paterno
	DECLARE Var_ApeMat					VARCHAR(50);			-- Apellido materno
	DECLARE Var_Control					VARCHAR(100);			-- Variable de control
	DECLARE Var_Consecutivo				VARCHAR(70);			-- Variable consecutivo
    DECLARE Var_PalabraInconveniente	CHAR(4);				-- Palabra inconveniente
    DECLARE Var_PalabraSustituida		CHAR(4);    			-- Palabra sustituida
    DECLARE VarControlSimbolo			INT(11);				-- CONTROL SIMBOLO
    DECLARE Var_ValidaVocal				INT(11);				-- Valida si es vocal
    DECLARE Var_PosSimbolo				INT(11);				-- POS SIMBOLO
	DECLARE Var_PerfilWsVbc				INT(11);				-- PERFIL OPERACIONES VBC

	-- Declaracion de Constantes
	DECLARE FechaVacia					DATE;					-- FECHA VACIA
	DECLARE Entero_Cero					INT(11);				-- ENTERO CERO
	DECLARE GeneroHombre				CHAR(1);				-- Genero Hombre
	DECLARE GeneroMujer					CHAR(1);				-- Genero Mujer
	DECLARE CadenaSI					CHAR(1);				-- CADENA SI
	DECLARE CadenaNO					CHAR(1);				-- CADENA NO
    DECLARE CadenaNacional				CHAR(1);				-- CADENA NACIONAL
    DECLARE CadenaExtranjero			CHAR(1);				-- EXTRANJERO
	DECLARE FechaNacimientoPivote		DATE;					-- FECHA NACIMIENTO
	DECLARE Cli_Nombre					VARCHAR(150);			-- Nombre del Cliente
	DECLARE appOriginal					VARCHAR(50);			-- APP ORIGINAL
	DECLARE Cli_NomHom					VARCHAR(150);			-- CLIENTE NOMBRE
	DECLARE Cli_AppHom					VARCHAR(50);			-- APELLIDO
	DECLARE Cli_ApmHom					VARCHAR(50);			-- AP MATERNO
	DECLARE Str_FecNac					VARCHAR(10);			-- FECHA NACIMIENTO
	DECLARE Str_FecNac2					VARCHAR(10);			-- FECHA NACIMIENTO
	DECLARE Str_FecNac3					VARCHAR(10);			-- FECHA NACIMIENTO
	DECLARE Cli_HomCve					VARCHAR(3);				-- CLAVE HOMBRE
	DECLARE aux							VARCHAR(5);				-- AUXILIAR
	DECLARE pos							INT(11);				-- POS
	DECLARE C_RFC						VARCHAR(13); 			-- RFC
	DECLARE Cli_RFC						VARCHAR(13); 			-- RFC
	DECLARE cadenaVacia					CHAR(1);				-- CADENA VACIA
	DECLARE CadFormada					VARCHAR(70);			-- CADENA FORMADA
    DECLARE LetraX						CHAR(1);				-- Letra X
    DECLARE LetraA						CHAR(1);				-- Letra A
    DECLARE LetraE						CHAR(1);				-- Letra E
    DECLARE LetraI						CHAR(1);				-- Letra I
    DECLARE LetraO						CHAR(1);				-- Letra O
    DECLARE LetraU						CHAR(1);				-- Letra U
    DECLARE LetraEnie					CHAR(1);				-- Letra Ñ
    DECLARE TxtNe						CHAR(2);				-- Texto NE
    DECLARE TxtJose						CHAR(4);				-- Texto JOSE
    DECLARE TxtJoseAc					CHAR(5);				-- Texto José
    DECLARE TxtMariaAc					CHAR(6);				-- Texto María
    DECLARE TxtMaria 					CHAR(5);				-- Texto Maria
    DECLARE Acento						CHAR(1);				-- Acento
    DECLARE Apostrofe					CHAR(1);				-- Apostrofe
    DECLARE Asterisco					CHAR(1);				-- Asterisco
    DECLARE GuionBajo					CHAR(1);				-- Guion Bajo
    DECLARE TxtCURP						CHAR(4);   				-- Texto CURP
    DECLARE Diagonal					CHAR(1);				-- Diagonal
    DECLARE Guion						CHAR(1);				-- Guion
    DECLARE Punto						CHAR(1);				-- Punto
	DECLARE SimbInterrogacion			VARCHAR(1);				-- Signo de interrogacion
    DECLARE Estatus_Activo				CHAR(1);				-- ESTATUS ACTIVO

	-- Asignacion de Constantes
	SET Entero_Cero						:= 0;									-- Cadena vacia
	SET cadenaVacia						:= '';									-- Cadena vacia
	SET C_RFC							:= '';									-- Caracteres para el RFC se ocupa en la variable Var_LetrasRFC
	SET Cli_RFC							:= '';									-- Caracteres para el RFC
	SET CadFormada						:= '';									-- Cadena formada (cadena a la que se le aplica la limpieza)
	SET appOriginal						:= Var_ApePat;							-- Apellido paterno origina
	SET FechaVacia						:= '1900-01-01';						-- Fecha Vacia
	SET Entero_Cero						:= 0;									-- Entero Cero
	SET GeneroHombre					:= 'H';									-- H = Hombre(Masculino)
	SET GeneroMujer						:= 'M';									-- M = Mujer(Femenino)
	SET CadenaSI						:= 'S';									-- Cadena para representar un SI
	SET CadenaNO						:= 'N';									-- Cadena para representar un NO
    SET CadenaNacional					:= 'N';									-- N.- Nacional
    SET CadenaExtranjero				:= 'E';									-- E. Extranjero
	SET FechaNacimientoPivote			:= '1999-12-31';						-- Fecha pivote para identificar si caracter progresivo es 0 o A
	SET SimbInterrogacion				:= '?';									-- Simbolo de interrogación

    SET Par_PrimerNombre   				:= REPLACE(Par_PrimerNombre, SimbInterrogacion, cadenaVacia);		-- PRIMER NOMBRE
    SET Par_SegundoNombre   			:= REPLACE(Par_SegundoNombre, SimbInterrogacion, cadenaVacia);		-- SEGUNDO NOMBRE
    SET Par_TercerNombre    			:= REPLACE(Par_TercerNombre, SimbInterrogacion, cadenaVacia);		-- TERCER NOMBRE
    SET Par_ApellidoPat	  				:= REPLACE(Par_ApellidoPat, SimbInterrogacion, cadenaVacia);		-- APELLIDO PATERNO
    SET Par_ApellidoMat	  				:= REPLACE(Par_ApellidoMat, SimbInterrogacion, cadenaVacia);		-- APELLIDO MATERNO
	SET Cli_Nombre						:= CONCAT(Par_PrimerNombre, " ", Par_SegundoNombre, " ", Par_TercerNombre);	-- NOMBRE
	SET Cli_Nombre						:= RTRIM(LTRIM(Cli_Nombre));			-- NOMBRE
	SET Var_ApePat						:= Par_ApellidoPat;						-- AP PATERNO
	SET Var_ApeMat						:= Par_ApellidoMat;						-- AP MATERNO
    SET LetraX							:= 'X';									-- X
    SET LetraA							:= 'A';									-- A
    SET LetraE							:= 'E';									-- E
    SET LetraI							:= 'I';									-- I
    SET LetraO							:= 'O';									-- O
    SET LetraU							:= 'U';									-- U
	SET LetraEnie						:= 'Ñ';									-- Ñ
    SET TxtNe							:= 'NE';								-- NE
    SET TxtJose							:= 'JOSE';								-- JOSE
    SET TxtJoseAc						:= 'JOSÉ';								-- JOSE
    SET TxtMariaAc						:= 'MARÍA';								-- MARIA
    SET TxtMaria						:= 'MARIA';								-- MARIA
    SET Acento							:= '´';									-- APOS
    SET Apostrofe						:= "'";									-- APOS
	SET Asterisco						:= '*';									-- POR
    SET GuionBajo						:= '_';									-- GUION BAJO
    SET TxtCURP							:= 'CURP';								-- CURP
    SET Diagonal						:= '/';									-- DIAGONAL
    SET Guion							:= '-';									-- GUION MEDIO
    SET Punto							:= '.';									-- PUNTO
	SET Estatus_Activo					:= 'A';									-- A

	-- Inicializa la variable de salida como error
	SET Par_NumErr  := 1;
	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIENTECURPWSCAL');
			SET Var_Control = 'sqlException' ;
		END;

    SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);

    IF(Var_PerfilWsVbc = Entero_Cero)THEN
    	SET Par_NumErr		:= '60';
		SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
		LEAVE ManejoErrores;
    END IF;


	SET Par_Usuario			:= REPLACE(Par_Usuario, SimbInterrogacion, cadenaVacia);
    SET Par_Clave			:= REPLACE(Par_Clave, SimbInterrogacion, cadenaVacia);

	IF IFNULL(Par_Usuario, cadenaVacia) = cadenaVacia THEN
		SET Par_ErrMen		:= 'El Usuario esta Vacio.';
		SET Par_NumErr		:= 001;
		SET Var_Control		:= 'Par_Usuario';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

    IF IFNULL(Par_Clave, cadenaVacia) = cadenaVacia THEN
    	SET Par_ErrMen		:= 'La Clave del Usuario esta Vacia.';
		SET Par_NumErr		:= 002;
		SET Var_Control		:= 'Par_Clave';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF NOT EXISTS (SELECT Clave
					FROM USUARIOS
					WHERE Clave = Par_Usuario AND Contrasenia = Par_Clave And Estatus = Estatus_Activo AND RolID = Var_PerfilWsVbc) THEN
		SET Par_ErrMen		:= 'El Usuario o la Clave Son Incorrectos.';
		SET Par_NumErr		:= 027;
		SET Var_Control		:= 'Par_Clave';
		SET Var_Consecutivo := Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

		IF IFNULL(Par_PrimerNombre, cadenaVacia) = cadenaVacia THEN
			SET Par_ErrMen		:= 'El Primer Nombre esta Vacío.';
			SET Par_NumErr		:= 001;
			SET Var_Control		:= 'Par_PrimerNombre';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_ApellidoPat, cadenaVacia) = cadenaVacia THEN
			SET Par_ErrMen		:= 'El Apellido Paterno esta Vacío.';
			SET Par_NumErr		:= 002;
			SET Var_Control		:= 'Par_PrimerNombre';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF( (IFNULL(Cli_Nombre,' ') = ' ') OR (Cli_Nombre=cadenaVacia) ) THEN
			SET Par_ErrMen		:= 'El Nombre no Puede ser Vacio.';
			SET Par_NumErr		:= 001;
			SET Var_Control		:= 'Cli_Nombre';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF( (	IFNULL(Var_ApePat, ' ') = ' ') OR (Var_ApePat=cadenaVacia) ) THEN
			SET Var_ApePat = cadenaVacia;
		END IF;

		IF( (IFNULL(Var_ApeMat,' ') = ' ') OR (Var_ApeMat=cadenaVacia) )THEN
			SET Var_ApeMat = cadenaVacia;
		END IF;

		IF( (Var_ApeMat=cadenaVacia) AND (Var_ApePat=cadenaVacia) ) THEN
			SET Par_ErrMen		:= 'Ambos Apellidos no Pueden ser Vacios.' ;
			SET Par_NumErr		:= 002;
			SET Var_Control		:= 'Var_ApeMat';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF Par_Genero NOT IN (GeneroHombre, GeneroMujer) THEN
			SET Par_ErrMen		:= 'Debe Indicar el Genero, H = Hombre(Masculino) o M = Mujer(Femenino)' ;
			SET Par_NumErr		:= 003;
			SET Var_Control		:= 'Par_Genero';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_FecNac, FechaVacia) = FechaVacia THEN
			SET Par_ErrMen		:= 'Debe Indicar la Fecha de Nacimiento.';
			SET Par_NumErr		:= 002;
			SET Var_Control		:= 'Par_FecNac';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF IFNULL(Par_Nacionalidad, cadenaVacia) = cadenaVacia OR Par_Nacionalidad NOT IN (CadenaNacional,CadenaExtranjero) THEN
			SET Par_ErrMen		:= 'Debe Indicar si es o no Extranjero.';
			SET Par_NumErr		:= 002;
			SET Var_Control		:= 'Par_Nacionalidad';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF Par_Nacionalidad = CadenaNacional  AND IFNULL(Par_EntidadFed, Entero_Cero) = Entero_Cero THEN
			SET Par_ErrMen		:= 'Debe Indicar la Entidad Federativa(Estado) de Nacimiento.';
			SET Par_NumErr		:= 002;
			SET Var_Control		:= 'Par_Nacionalidad';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        -- Validacion
        SET Var_PosSimbolo :=  LOCATE(Punto, Par_ApellidoPat);


        IF(Var_PosSimbolo >=2) THEN
			SET VarControlSimbolo := 1;
		ELSE
			SET Var_PosSimbolo :=  LOCATE(Diagonal, Par_ApellidoPat);
			IF(Var_PosSimbolo >=2) THEN
				SET VarControlSimbolo := 1;
			ELSE
				SET Var_PosSimbolo :=  LOCATE(Guion, Par_ApellidoPat);
				IF(Var_PosSimbolo >=2) THEN
					SET VarControlSimbolo := 1;
				ELSE
					SET	VarControlSimbolo := 0;
				END IF;
			END IF;
		END IF;

        --  Si los Apellidos o Nombres contienen simbolos como el guion,punto o diagonal se sustituye por la letra X
        SET Par_ApellidoPat		 := REPLACE(Par_ApellidoPat, Punto, LetraX);
		SET Par_ApellidoMat		 := REPLACE(Par_ApellidoMat, Punto, LetraX);
		SET Var_ApePat			 := REPLACE(Par_ApellidoPat, Punto, LetraX);
		SET Var_ApeMat			 := REPLACE(Par_ApellidoMat, Punto, LetraX);
        IF Par_PrimerNombre NOT IN ('MA.') THEN
			SET Par_PrimerNombre	 := REPLACE(Par_PrimerNombre, Punto, LetraX);
            SET Cli_Nombre			 := REPLACE(Cli_Nombre, Punto, LetraX);
            SET Par_SegundoNombre	 := REPLACE(Par_SegundoNombre, Punto, LetraX);
			SET Par_TercerNombre	 := REPLACE(Par_TercerNombre, Punto, LetraX);
		ELSE
			SET Par_PrimerNombre	 := Par_SegundoNombre;
			SET Cli_Nombre := CONCAT(Par_SegundoNombre, " ", Par_TercerNombre);
            SET Cli_Nombre			 := REPLACE(Cli_Nombre, Punto, LetraX);
			SET Par_SegundoNombre	 := REPLACE(Par_SegundoNombre, Punto, LetraX);
			SET Par_TercerNombre	 := REPLACE(Par_TercerNombre, Punto, LetraX);
		END IF;



        SET Par_PrimerNombre	 := REPLACE(Par_PrimerNombre, Diagonal, LetraX);
        SET Par_SegundoNombre	 := REPLACE(Par_SegundoNombre, Diagonal, LetraX);
        SET Par_TercerNombre	 := REPLACE(Par_TercerNombre, Diagonal, LetraX);
        SET Par_ApellidoPat		 := REPLACE(Par_ApellidoPat, Diagonal, LetraX);
        SET Par_ApellidoMat		 := REPLACE(Par_ApellidoMat, Diagonal, LetraX);
        SET Var_ApePat			 := REPLACE(Par_ApellidoPat, Diagonal, LetraX);
		SET Var_ApeMat			 := REPLACE(Par_ApellidoMat, Diagonal, LetraX);
        SET Cli_Nombre		 	 := REPLACE(Cli_Nombre, Diagonal, LetraX);

		SET Par_PrimerNombre	 := REPLACE(Par_PrimerNombre, Guion, LetraX);
        SET Par_SegundoNombre	 := REPLACE(Par_SegundoNombre, Guion, LetraX);
        SET Par_TercerNombre	 := REPLACE(Par_TercerNombre, Guion, LetraX);
        SET Par_ApellidoPat		 := REPLACE(Par_ApellidoPat, Guion, LetraX);
		SET Par_ApellidoMat		 := REPLACE(Par_ApellidoMat, Guion, LetraX);
        SET Var_ApePat			 := REPLACE(Par_ApellidoPat, Guion, LetraX);
		SET Var_ApeMat			 := REPLACE(Par_ApellidoMat, Guion, LetraX);

        SET Cli_Nombre			 := REPLACE(Cli_Nombre, Guion, LetraX);


        -- Limpia si hay caracteres especiales
		SET Par_PrimerNombre := FNLIMPIACARACTERESPECIAL(Par_PrimerNombre,'3');
		SET Par_PrimerNombre := FNLIMPIACARACTERESPECIAL(Par_PrimerNombre,'1');
		SET Par_PrimerNombre := FNLIMPIACARACTERESPECIAL(Par_PrimerNombre,'2');

		SET Par_SegundoNombre := FNLIMPIACARACTERESPECIAL(Par_SegundoNombre,'3');
		SET Par_SegundoNombre := FNLIMPIACARACTERESPECIAL(Par_SegundoNombre,'1');
		SET Par_SegundoNombre := FNLIMPIACARACTERESPECIAL(Par_SegundoNombre,'2');

		SET Par_TercerNombre := FNLIMPIACARACTERESPECIAL(Par_TercerNombre,'3');
		SET Par_TercerNombre := FNLIMPIACARACTERESPECIAL(Par_TercerNombre,'1');
		SET Par_TercerNombre := FNLIMPIACARACTERESPECIAL(Par_TercerNombre,'2');

		SET Par_ApellidoPat := FNLIMPIACARACTERESPECIAL(Par_ApellidoPat,'3');
		SET Par_ApellidoPat := FNLIMPIACARACTERESPECIAL(Par_ApellidoPat,'1');
		SET Par_ApellidoPat := FNLIMPIACARACTERESPECIAL(Par_ApellidoPat,'2');

		SET Par_ApellidoMat := FNLIMPIACARACTERESPECIAL(Par_ApellidoMat,'3');
		SET Par_ApellidoMat := FNLIMPIACARACTERESPECIAL(Par_ApellidoMat,'1');
		SET Par_ApellidoMat := FNLIMPIACARACTERESPECIAL(Par_ApellidoMat,'2');

		SET Str_FecNac := CAST(DATE_FORMAT(Par_FecNac,'%y%m%d') AS CHAR);
		SET CadFormada := FNLIMPIACARACTERESPECIAL(Cli_Nombre, '3');
		SET	Cli_Nombre := CadFormada;

		SET CadFormada := FNLIMPIACARACTERESPECIAL(Var_ApePat,'3');
		SET	Var_ApePat := CadFormada;

		SET CadFormada := FNLIMPIACARACTERESPECIAL(Var_ApeMat,'3');
		SET	Var_ApeMat := CadFormada;
		SET	Cli_NomHom := Cli_Nombre;
		SET	Cli_AppHom := Var_ApePat;
		SET	Cli_ApmHom := Var_ApeMat;

		SET CadFormada := FNLIMPIACARACTERESPECIAL(Cli_NomHom, '1');
		SET	Cli_NomHom := CadFormada;
		SET CadFormada := FNLIMPIACARACTERESPECIAL(Cli_AppHom, '1');
		SET	Cli_AppHom := CadFormada;
		SET CadFormada := FNLIMPIACARACTERESPECIAL(Cli_ApmHom,'1');
		SET	Cli_ApmHom := CadFormada;

		SET CadFormada := FNLIMPIACARACTERESPECIAL(Cli_Nombre, '2');
		SET	Cli_Nombre := CadFormada;
		SET CadFormada := FNLIMPIACARACTERESPECIAL(Var_ApePat, '2');
		SET	Var_ApePat := CadFormada;
		SET CadFormada := FNLIMPIACARACTERESPECIAL(Var_ApeMat, '2');
		SET	Var_ApeMat := CadFormada;

		IF( (IFNULL(Cli_NomHom, ' ') = ' ') OR (Cli_NomHom=cadenaVacia) )THEN
			SET Cli_NomHom := cadenaVacia;
		END IF;
		IF( (IFNULL(Cli_AppHom, ' ') = ' ') OR (Cli_AppHom=cadenaVacia) )THEN
			SET Cli_AppHom :=cadenaVacia;
		END IF;
		IF( (IFNULL(Cli_ApmHom, ' ') = ' ') OR (Cli_ApmHom=cadenaVacia) )THEN
			SET Cli_ApmHom :=cadenaVacia;
		END IF;
		IF( (IFNULL(Cli_Nombre, ' ') = ' ') OR (Cli_Nombre=cadenaVacia) ) THEN
			SET Cli_Nombre := cadenaVacia;
		END IF;
		IF( (IFNULL(Var_ApePat, ' ') = ' ') OR (Var_ApePat=cadenaVacia) ) THEN
			SET Var_ApePat := cadenaVacia;
		END IF;
		IF( (IFNULL(Var_ApeMat, ' ') = ' ') OR (Var_ApeMat=cadenaVacia) ) THEN
			SET Var_ApeMat := cadenaVacia;
		END IF;

		IF( Cli_Nombre <> REPLACE(Cli_Nombre, ' ', LetraX) ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 2) = 'J ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 3, CHAR_LENGTH(Cli_Nombre) );
			END IF;
		END IF;
		IF( Cli_Nombre <> REPLACE(Cli_Nombre,' ', LetraX) ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 3) = 'MA ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 4, CHAR_LENGTH(Cli_Nombre) );
			END IF;
		END IF;
		IF( Cli_Nombre <> REPLACE(Cli_Nombre, ' ', LetraX) ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 5) = 'JOSE ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 6, CHAR_LENGTH(Cli_Nombre) );
			END IF;
		END IF;
		IF( Cli_Nombre <> REPLACE(Cli_Nombre,' ', LetraX) ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 6) = 'MARIA ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 7, CHAR_LENGTH(Cli_Nombre) );
			END IF;
		END IF;

		SET Cli_RFC := cadenaVacia;

		IF( (Var_ApeMat=cadenaVacia) OR (Var_ApePat=cadenaVacia) ) THEN
			IF( Var_ApePat =cadenaVacia)THEN
				SET Var_ApePat := Var_ApeMat;
				IF( CHAR_LENGTH(Var_ApePat) < 2 ) THEN
					SET Cli_RFC := CONCAT(SUBSTR(Var_ApePat,1,1),SUBSTR(Cli_Nombre,1,2));

					IF( CHARINDEX( ' ', Cli_Nombre) > 0 ) THEN
						SET Cli_RFC := CONCAT(LTRIM(Cli_RFC),SUBSTR(Cli_Nombre, CHARINDEX( ' ', Cli_Nombre)+1, 1));
					ELSE
						SET Cli_RFC := CONCAT(LTRIM(Cli_RFC),LetraX);
					END IF;
				ELSE
					SET Cli_RFC := CONCAT(SUBSTR(Var_ApePat,1,2),SUBSTR(Cli_Nombre,1,2));
				END IF;
			END IF;
            -- Si solo tiene Apellido Paterno, se le asigna X en la tercera posicion
            IF( Var_ApeMat =cadenaVacia)THEN
            SET Cli_RFC := CONCAT(SUBSTR(Var_ApePat,1,2),LetraX,SUBSTR(Cli_Nombre,1,1));
            SET Var_ApeMat := LetraX;

			END IF;
		END IF;
		IF( CHAR_LENGTH(LTRIM(RTRIM(appOriginal))) <= 3 ) THEN
			SET Cli_RFC := CONCAT(SUBSTR(Var_ApePat,1,1),SUBSTR(Var_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));

		ELSE
			SET Cli_RFC := SUBSTR(Var_ApePat,1,1);
			SET pos:=2;
            SET Var_ValidaVocal = 0;
			WHILE pos <=CHAR_LENGTH(Var_ApePat) DO

				SET aux := SUBSTR(Var_ApePat,pos,1);
				IF( (aux = LetraA) OR (aux = LetraE) OR (aux = LetraI) OR (aux = LetraO) OR (aux = LetraU) ) THEN
					SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Var_ApePat,pos,1));
					SET pos := CHAR_LENGTH(RTRIM(Var_ApePat));
				     SET Var_ValidaVocal := 1;
				END IF;

				SET pos := pos + 1;
			END WHILE;
            -- Valida si encuentra una vocal que la asigne al apellido paterno, si no que la sustituya por una X
            IF Var_ValidaVocal = 0 THEN
					SET Cli_RFC := CONCAT(SUBSTR(Var_ApePat,1,1),LetraX,SUBSTR(Var_ApeMat,1,1),SUBSTR(Cli_Nombre,1,1));
                ELSE
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Var_ApeMat,1,1),SUBSTR(Cli_Nombre,1,1));
		END IF;
		END IF;

            IF(VarControlSimbolo = 1) THEN
				SET Cli_RFC := CONCAT(SUBSTR(Var_ApePat,1,1),LetraX,SUBSTR(Var_ApeMat,1,1),SUBSTR(Cli_Nombre,1,1));
                END IF;
		-- Verificar si los primeros 4 caracteres  no forman una palabra inconveniente
		SET aux := RTRIM(Cli_RFC);
		SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),RTRIM(Str_FecNac));
			SELECT PalabraInconv, PalabraSustituida
				INTO Var_PalabraInconveniente, Var_PalabraSustituida
				FROM CATALOGOPALABINCONV
				WHERE PalabraInconv = aux;

        IF (Var_PalabraInconveniente=aux)
			THEN
				SET C_RFC := CONCAT(Var_PalabraSustituida,SUBSTR(Cli_RFC, 5, 9));

            ELSE
				SET C_RFC :=(RTRIM(Cli_RFC));


		END IF;

		SET C_RFC :=(RTRIM(C_RFC));

		--  ==========================  CALCULO DE CURP ============================
		SET Var_LetrasRFC		:= SUBSTR(C_RFC, 1,4);
		SET Var_LetrasRFC		:= REPLACE(Var_LetrasRFC, LetraEnie, LetraX);
		SET Var_FechaNacimiento := CAST(DATE_FORMAT(Par_FecNac,'%y%m%d') AS CHAR);


		IF Par_Nacionalidad = CadenaNacional THEN
			SET Var_Entidad		 := (SELECT Clave FROM ESTADOSREPUB WHERE EstadoID = Par_EntidadFed);
            IF IFNULL(Var_Entidad, cadenaVacia) = cadenaVacia THEN
				SET Par_ErrMen		:= 'La Entidad Federativa (Estado) No Existe.';
				SET Par_NumErr		:= '008';
				SET Var_Control		:= 'Par_EntidadFed';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
            END IF;
		ELSE
			SET Var_Entidad		 := TxtNe;
		END IF;


		IF Par_PrimerNombre IN (TxtJoseAc,TxtJose,TxtMariaAc,TxtMaria) AND IFNULL(Par_SegundoNombre, cadenaVacia) <> cadenaVacia THEN
			SET Var_NombreConsonante := Par_SegundoNombre;
		ELSE
			SET Var_NombreConsonante := Par_PrimerNombre;
		END IF;

		-- Obtener la Consonante interna del Apellido Paterno
		SET Var_Letra			 := LetraX;
		SET Par_ApellidoPat		 := REPLACE(Par_ApellidoPat, Acento, GuionBajo);
		SET Par_ApellidoPat		 := REPLACE(Par_ApellidoPat, Apostrofe, GuionBajo);
		SET Par_ApellidoPat		 := REPLACE(Par_ApellidoPat, Asterisco, GuionBajo);
		IF CHAR_LENGTH(Par_ApellidoPat) >= 2 THEN

			SET Var_PosicionCiclo		:= 2;
			SET Var_ApePat			  := cadenaVacia;

			BUSQUEDAENAPELLIDOPAT: WHILE Var_PosicionCiclo <= (CHAR_LENGTH(Par_ApellidoPat)) DO
				SET Var_LetraAux	:= SUBSTR(Par_ApellidoPat, Var_PosicionCiclo, 1);

				IF ASCII(Var_LetraAux) IN (209) THEN  -- Letra  Ñ
					 SET Var_Letra				:= LetraX;
					LEAVE BUSQUEDAENAPELLIDOPAT;
				END IF;

				IF ASCII(Var_LetraAux) NOT IN (65,69,73,79,85,ASCII(GuionBajo)) THEN  -- (A,E,I,O,U)
					SET Var_Letra			:= Var_LetraAux;
					SET Var_PosicionCiclo	:= CHAR_LENGTH(Par_ApellidoPat);
				END IF;

				SET Var_PosicionCiclo	:= Var_PosicionCiclo + 1;

			END WHILE BUSQUEDAENAPELLIDOPAT;
		END IF;

		SET Var_Consonantes	 := Var_Letra;

		-- Obtener la Consonante interna del Apellido Materno
		SET Var_Letra := LetraX;
		SET Par_ApellidoMat		 := REPLACE(Par_ApellidoMat, Acento, GuionBajo);
		SET Par_ApellidoMat		 := REPLACE(Par_ApellidoMat, Apostrofe, GuionBajo);
		SET Par_ApellidoMat		 := REPLACE(Par_ApellidoMat, Asterisco, GuionBajo);

		IF CHAR_LENGTH(Par_ApellidoMat) >= 3 THEN

			SET Var_PosicionCiclo		:= 2;

			BUSQUEDAENAPELLIDOMAT: WHILE Var_PosicionCiclo <= (CHAR_LENGTH(Par_ApellidoMat)) DO

				SET Var_LetraAux	 := SUBSTR(Par_ApellidoMat, Var_PosicionCiclo, 1);
				IF ASCII(Var_LetraAux) IN (209) THEN
					SET Var_Letra	:= LetraX;
					LEAVE BUSQUEDAENAPELLIDOMAT;
				END IF;
				IF ASCII(Var_LetraAux) NOT IN (65,69,73,79,85,ASCII(GuionBajo)) THEN
					SET Var_Letra			:= Var_LetraAux;
					SET Var_PosicionCiclo	:= CHAR_LENGTH(Par_ApellidoMat);
				END IF;
				SET Var_PosicionCiclo	:= Var_PosicionCiclo + 1;
			END WHILE BUSQUEDAENAPELLIDOMAT;
		END IF;

		SET Var_Consonantes	 := CONCAT(LTRIM(RTRIM(Var_Consonantes)), Var_Letra);

		-- Obtener la Consonante interna del Nombre
		SET Var_Letra := LetraX;

		IF CHAR_LENGTH(Var_NombreConsonante) >= 3 THEN
			SET Var_PosicionCiclo		:= 2;

			BUSQUEDAENNOMBRE: WHILE Var_PosicionCiclo <= (CHAR_LENGTH(Var_NombreConsonante)) DO
				SET Var_LetraAux	 := SUBSTR(Var_NombreConsonante, Var_PosicionCiclo, 1);
				IF ASCII(Var_LetraAux) IN (209) THEN
					SET Var_Letra				:= LetraX;
					LEAVE BUSQUEDAENNOMBRE;
				END IF;

				IF ASCII(Var_LetraAux) NOT IN (65,69,73,79,85) THEN
					SET Var_Letra			:= Var_LetraAux;
					SET Var_PosicionCiclo	:= CHAR_LENGTH(Var_NombreConsonante);
				END IF;
				SET Var_PosicionCiclo	:= Var_PosicionCiclo + 1;

			END WHILE BUSQUEDAENNOMBRE;
		END IF;

		SET Var_Consonantes	 := CONCAT(LTRIM(RTRIM(Var_Consonantes)), Var_Letra);

		IF Par_FecNac <= FechaNacimientoPivote THEN
			SET Var_CaracterProgresivo	  := Entero_Cero;
		ELSE
			SET Var_CaracterProgresivo	  := LetraA;
		END IF;

		SET Var_CURP			:= CONCAT(Var_LetrasRFC,Var_FechaNacimiento,Par_Genero,Var_Entidad,Var_Consonantes,Var_CaracterProgresivo);

		-- Calcular Digito Verificador
		SET Var_ValorPosicion	:= 18;
		SET Var_PosicionCiclo	:= 1;
		SET Var_ResiduoBase10	:= Entero_Cero;

		WHILE Var_PosicionCiclo <= (CHAR_LENGTH(Var_CURP) ) DO
			SET Var_Caracter		:= SUBSTR(Var_CURP, Var_PosicionCiclo, 1);
			SET Var_ValorCaracter	:= CASE Var_Caracter WHEN  '0' THEN 0
														 WHEN  '1' THEN 1
														 WHEN  '2' THEN 2
														 WHEN  '3' THEN 3
														 WHEN  '4' THEN 4
														 WHEN  '5' THEN 5
														 WHEN  '6' THEN 6
														 WHEN  '7' THEN 7
														 WHEN  '8' THEN 8
														 WHEN  '9' THEN 9
														 WHEN  'A' THEN 10
														 WHEN  'B' THEN 11
														 WHEN  'C' THEN 12
														 WHEN  'D' THEN 13
														 WHEN  'E' THEN 14
														 WHEN  'F' THEN 15
														 WHEN  'G' THEN 16
														 WHEN  'H' THEN 17
														 WHEN  'I' THEN 18
														 WHEN  'J' THEN 19
														 WHEN  'K' THEN 20
														 WHEN  'L' THEN 21
														 WHEN  'M' THEN 22
														 WHEN  'N' THEN 23
														 WHEN  'Ñ' THEN 24
														 WHEN  'O' THEN 25
														 WHEN  'P' THEN 26
														 WHEN  'Q' THEN 27
														 WHEN  'R' THEN 28
														 WHEN  'S' THEN 29
														 WHEN  'T' THEN 30
														 WHEN  'U' THEN 31
														 WHEN  'V' THEN 32
														 WHEN  'W' THEN 33
														 WHEN  'X' THEN 34
														 WHEN  'Y' THEN 35
														 WHEN  'Z' THEN 36
										END;
			SET Var_ResiduoBase10	:= Var_ResiduoBase10 + (Var_ValorCaracter * Var_ValorPosicion );
			SET Var_ValorPosicion	:= Var_ValorPosicion - 1;
			SET Var_PosicionCiclo	:= Var_PosicionCiclo + 1;
		END WHILE;

		SET Var_ResiduoBase10		:= MOD(Var_ResiduoBase10,10);
        IF(Var_ResiduoBase10 = Entero_Cero)THEN
			SET Var_DigitoVerificador	:= Entero_Cero;
		ELSE
			SET Var_DigitoVerificador	:= CAST((10 - Var_ResiduoBase10) AS CHAR);
		END IF;
        SET Par_CURP				:= CONCAT(Var_CURP, Var_DigitoVerificador);

		-- Se resetea la variable de salida como Exito
		SET Par_NumErr  := '00';
		SET Par_ErrMen	:= 'CURP Generada Exitosamente';
		SET Var_Control := TxtCURP;
		SET Var_Consecutivo := Par_CURP;

	END ManejoErrores;

	IF (Par_Salida = CadenaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				UPPER(Par_CURP) AS 'Curp',
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$