-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEWSRFCCAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEWSRFCCAL`;DELIMITER $$

CREATE PROCEDURE `CLIENTEWSRFCCAL`(
/*SP Para generar el RFC del cliente*/
	Cli_Nombre			VARCHAR(150),	-- NOMBRE
	Cli_ApePat			VARCHAR(50),	-- AP PATERNO
	Cli_ApeMat			VARCHAR(50),	-- AP MATERNO
	Cli_FecNac			DATE,			-- FECHA NAC
    Par_Usuario			VARCHAR(20),	-- USUARIO

    Par_Clave			VARCHAR(100),   -- CLAVE
    Par_Salida          CHAR(1),        -- Indica el tipo de salida del sp
    INOUT Par_NumErr    INT,            -- Numero de error
    INOUT Par_ErrMen    VARCHAR(400),   -- Mensaje de error
    INOUT Par_RFC		VARCHAR(13),	-- RFC

    Par_EmpresaID		INT,			-- AUDITORIA
	Aud_Usuario			INT,			-- AUDITORIA
	Aud_FechaActual		DATETIME,		-- AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal		INT,			-- AUDITORIA
	Aud_NumTransaccion	BIGINT			-- AUDITORIA
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control			VARCHAR(100);			-- Variable de control
	DECLARE Var_Consecutivo		VARCHAR(70);			-- Variable consecutivo
	DECLARE Var_PerfilWsVbc		INT(11);				-- PERFIL OPERACIONES VBC


	-- Declaracion de constantes
	DECLARE	appOriginal			VARCHAR(50);			-- APP ORIGINAL
	DECLARE	Cli_NomHom			VARCHAR(70);			-- NOMBRE
	DECLARE	Cli_AppHom			VARCHAR(50);			-- AP PATERNO
	DECLARE	Cli_ApmHom			VARCHAR(50);			-- AP MATERNO
	DECLARE	Str_FecNac			VARCHAR(10);			-- FECHA NAC
	DECLARE	Str_FecNac2			VARCHAR(10);			-- FECHA NAC
	DECLARE	Str_FecNac3			VARCHAR(10);			-- FECHA NAC
	DECLARE	Cli_HomCve			VARCHAR(3);				-- CLAVE
	DECLARE	aux					VARCHAR(5);				-- AUX
	DECLARE	pos					INT;					-- POS
	DECLARE	C_RFC				VARCHAR(13); 			-- RFC
	DECLARE	Cli_RFC				VARCHAR(13); 			-- RFC
	DECLARE	Cadena_Vacia		CHAR(1);				-- CADENA VACIA
	DECLARE	CadFormada			VARCHAR(70);			-- CADENA FORMADA
	DECLARE	Salida_SI			CHAR(1);				-- SALIDA SI
	DECLARE Entero_Cero			INT(11);				-- ENTERO CERO
	DECLARE Fecha_Vacia			DATE;					-- FECHA VACIA
	DECLARE SimbInterrogacion	VARCHAR(1);				-- SIM INTERROGA
	DECLARE Estatus_Activo		CHAR(1);				-- ESTATUS ACTIVO

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia	:='';						-- CADENA VACIA
	SET C_RFC			:= '';						-- RFC
	SET Cli_RFC			:= '';						-- RFC
	SET CadFormada		:= '';						-- CADENA FORMADA
	SET appOriginal		:= Cli_ApePat;				-- APP ORIGINAL
	SET Entero_Cero		:= 0;						-- ENTERO CERO
	SET Fecha_Vacia		:= '1900-01-01';			-- FECHA VACIA
	SET SimbInterrogacion:= '?';					-- Simbolo de interrogación
	SET Estatus_Activo	:= 'A';						-- ESTATUS ACTIVO
	SET Salida_SI		:= 'S';						-- salida si
	SET Cli_Nombre   	:= REPLACE(Cli_Nombre, SimbInterrogacion, Cadena_Vacia);
	SET Cli_ApePat   	:= REPLACE(Cli_ApePat, SimbInterrogacion, Cadena_Vacia);
	SET Cli_ApeMat    	:= REPLACE(Cli_ApeMat, SimbInterrogacion, Cadena_Vacia);
	SET Par_Usuario		:= REPLACE(Par_Usuario, SimbInterrogacion, Cadena_Vacia);
	SET Par_Clave		:= REPLACE(Par_Clave, SimbInterrogacion, Cadena_Vacia);

	SET Var_PerfilWsVbc		:= (SELECT PerfilWsVbc FROM PARAMETROSSIS LIMIT 1);
    SET Var_PerfilWsVbc		:= IFNULL(Var_PerfilWsVbc,Entero_Cero);
    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIENTEWSRFCCAL');
		END;


	    IF(Var_PerfilWsVbc = Entero_Cero)THEN
	    	SET Par_NumErr		:= '60';
			SET Par_ErrMen		:= 'No existe perfil definido para el usuario.';
			LEAVE ManejoErrores;
	    END IF;

		IF IFNULL(Par_Usuario, Cadena_Vacia) = Cadena_Vacia THEN
			SET Par_NumErr		:= '06';
			SET Par_ErrMen		:= 'El Usuario esta Vacio';
			LEAVE ManejoErrores;
		END IF;

	    IF IFNULL(Par_Clave, Cadena_Vacia) = Cadena_Vacia THEN
	   		SET Par_NumErr		:= '07';
			SET Par_ErrMen		:= 'La Clave del Usuario esta Vacia.';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT Clave
						FROM USUARIOS
						WHERE Clave = Par_Usuario AND Contrasenia = Par_Clave And Estatus = Estatus_Activo AND RolID = Var_PerfilWsVbc) THEN
	   		SET Par_NumErr		:= '27';
			SET Par_ErrMen		:= 'El Usuario o la Clave Son Incorrectos.';
			LEAVE ManejoErrores;
		END IF;

		IF( (IFNULL(Cli_Nombre,Cadena_Vacia) = Cadena_Vacia) OR (Cli_Nombre=Cadena_Vacia) ) THEN
			SET Par_NumErr		:= '01';
			SET Par_ErrMen		:= 'El Nombre No Puede Estar Vacío.';
			LEAVE ManejoErrores;
		END IF;

		IF( (	IFNULL(Cli_ApePat, Cadena_Vacia) = Cadena_Vacia) OR (Cli_ApePat=Cadena_Vacia) ) THEN
			SET Cli_ApePat := Cadena_Vacia;
			SET Par_NumErr		:= '02';
			SET Par_ErrMen		:= 'El Apellido Paterno No Puede Estar Vacío.';
			LEAVE ManejoErrores;
		END IF;

		IF( (IFNULL(Cli_ApeMat,Cadena_Vacia) = Cadena_Vacia) OR (Cli_ApeMat=Cadena_Vacia) )THEN
			SET Cli_ApeMat := Cadena_Vacia;
		END IF;

		IF( (Cli_ApeMat=Cadena_Vacia) AND (Cli_ApePat=Cadena_Vacia) ) THEN
			SET Par_NumErr		:= '04';
			SET Par_ErrMen		:= 'Ambos apellidos no Pueden Estar Vacios.';
			LEAVE ManejoErrores;
		END IF;

		IF( IFNULL(Cli_FecNac, Fecha_Vacia) = Fecha_Vacia) THEN
			SET Par_NumErr		:= '03';
			SET Par_ErrMen		:= 'La Fecha de Nacimiento No Puede Estar Vacía.';
			LEAVE ManejoErrores;
		END IF;

		SET Str_FecNac	:= SUBSTR(Cli_FecNac,3,2);
		SET Str_FecNac2	:= SUBSTR(Cli_FecNac,6,2);
		SET Str_FecNac3	:= SUBSTR(Cli_FecNac,9,2);
		SET Str_FecNac	:= CONCAT(Str_FecNac,Str_FecNac2,Str_FecNac3);

		SET	Cli_Nombre := FNLIMPIACARACTERESPECIAL(Cli_Nombre,'3');
		SET	Cli_ApePat := FNLIMPIACARACTERESPECIAL(Cli_ApePat,'3');
		SET	Cli_ApeMat := FNLIMPIACARACTERESPECIAL(Cli_ApeMat,'3');
		SET	Cli_NomHom := Cli_Nombre;
		SET	Cli_AppHom := Cli_ApePat;
		SET	Cli_ApmHom := Cli_ApeMat;

		SET	Cli_NomHom := FNLIMPIACARACTERESPECIAL(Cli_NomHom,'1');
		SET	Cli_AppHom := FNLIMPIACARACTERESPECIAL(Cli_AppHom,'1');
		SET	Cli_ApmHom := FNLIMPIACARACTERESPECIAL(Cli_ApmHom,'1');

		SET	Cli_Nombre := FNLIMPIACARACTERESPECIAL(Cli_NomHom,'2');
		SET	Cli_ApePat := FNLIMPIACARACTERESPECIAL(Cli_ApePat,'2');
		SET	Cli_ApeMat := FNLIMPIACARACTERESPECIAL(Cli_ApeMat,'2');

		IF( (IFNULL(Cli_NomHom, Cadena_Vacia) = Cadena_Vacia) OR (Cli_NomHom=Cadena_Vacia) )THEN
			SET Cli_NomHom := Cadena_Vacia;
		END IF;
		IF( (IFNULL(Cli_AppHom, Cadena_Vacia) = Cadena_Vacia) OR (Cli_AppHom=Cadena_Vacia) )THEN
			SET Cli_AppHom := Cadena_Vacia;
		END IF;
		IF( (IFNULL(Cli_ApmHom, Cadena_Vacia) = Cadena_Vacia) OR (Cli_ApmHom=Cadena_Vacia) )THEN
			SET Cli_ApmHom := Cadena_Vacia;
		END IF;
		IF( (IFNULL(Cli_Nombre, Cadena_Vacia) = Cadena_Vacia) OR (Cli_Nombre=Cadena_Vacia) ) THEN
			SET Cli_Nombre := Cadena_Vacia;
		END IF;
		IF( (IFNULL(Cli_ApePat, Cadena_Vacia) = Cadena_Vacia) OR (Cli_ApePat=Cadena_Vacia) ) THEN
			SET Cli_ApePat := Cadena_Vacia;
		END IF;
		IF( (IFNULL(Cli_ApeMat, Cadena_Vacia) = Cadena_Vacia) OR (Cli_ApeMat=Cadena_Vacia) ) THEN
			SET Cli_ApeMat := Cadena_Vacia;
		END IF;


		IF( Cli_Nombre <> REPLACE(Cli_Nombre, ' ', 'X') ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 2) = 'J ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 3, LENGTH(Cli_Nombre) );
			END IF;
		END IF;
		IF( Cli_Nombre <> REPLACE(Cli_Nombre,' ', 'X') ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 3) = 'MA ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 4, LENGTH(Cli_Nombre) );
			END IF;
		END IF;
		IF( Cli_Nombre <> REPLACE(Cli_Nombre, ' ', 'X') ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 5) = 'JOSE ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 6, LENGTH(Cli_Nombre) );
			END IF;
		END IF;
		IF( Cli_Nombre <> REPLACE(Cli_Nombre,' ', 'X') ) THEN
			IF( SUBSTRING(Cli_Nombre, 1, 6) = 'MARIA ' )THEN
				SET	Cli_Nombre := SUBSTRING(Cli_Nombre, 7, LENGTH(Cli_Nombre) );
			END IF;
		END IF;

		SET Cli_RFC := Cadena_Vacia;

		IF( (Cli_ApeMat=Cadena_Vacia) OR (Cli_ApePat=Cadena_Vacia) ) THEN
			IF( Cli_ApePat =Cadena_Vacia)THEN
				SET Cli_ApePat := Cli_ApeMat;
			IF( LENGTH(Cli_ApePat) < 2 ) THEN
				SET Cli_RFC := CONCAT(SUBSTR(Cli_ApePat,1,1),SUBSTR(Cli_Nombre,1,2));

				IF( CHARINDEX( ' ', Cli_Nombre) > 0 ) THEN
					SET Cli_RFC := CONCAT(LTRIM(Cli_RFC),SUBSTR(Cli_Nombre, CHARINDEX( ' ', Cli_Nombre)+1, 1));
				ELSE
					SET Cli_RFC := CONCAT(LTRIM(Cli_RFC),'X');
				END IF;
			ELSE
				SET Cli_RFC := CONCAT(SUBSTR(Cli_ApePat,1,2),SUBSTR(Cli_Nombre,1,2));
			END IF;
		END IF;
		END IF;


		IF(Cli_ApeMat!=Cadena_Vacia) THEN
		IF( LENGTH(LTRIM(RTRIM(appOriginal))) <= 3 ) THEN
			SET Cli_RFC= CONCAT(SUBSTR(Cli_ApePat,1,1),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));

		ELSE
			SET Cli_RFC := SUBSTR(Cli_ApePat,1,1);
			SET pos=2;
			WHILE pos <=LENGTH(Cli_ApePat) DO
				SET aux := SUBSTR(Cli_ApePat,pos,1);
				IF( (aux = 'A') OR (aux = 'E') OR (aux = 'I') OR (aux = 'O') OR (aux = 'U') ) THEN
					SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApePat,pos,1));
					SET pos := LENGTH(RTRIM(Cli_ApePat));
				END IF;
				SET pos := pos + 1;
			END WHILE;
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,1));
		END IF;
		END IF;

		IF(Cli_ApeMat=Cadena_Vacia) THEN
		IF( LENGTH(LTRIM(RTRIM(appOriginal))) <= 3 ) THEN
			SET Cli_RFC= CONCAT(SUBSTR(Cli_ApePat,1,2),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));

		ELSE
			SET Cli_RFC := SUBSTR(Cli_ApePat,1,1);
			SET pos=2;
			WHILE pos <=LENGTH(Cli_ApePat) DO
				SET aux := SUBSTR(Cli_ApePat,pos,1);
				IF( (aux = 'A') OR (aux = 'E') OR (aux = 'I') OR (aux = 'O') OR (aux = 'U') ) THEN
					SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApePat,pos,1));
					SET pos := LENGTH(RTRIM(Cli_ApePat));
				END IF;
				SET pos := pos + 1;
			END WHILE;
			SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),SUBSTR(Cli_ApeMat,1,1),SUBSTR(Cli_Nombre,1,2));
		END IF;
		END IF;

		SET aux := RTRIM(Cli_RFC);
		SET Cli_RFC := CONCAT(RTRIM(Cli_RFC),RTRIM(Str_FecNac));

		SET C_RFC = FNRFCGENHOMOCAL(Cli_NomHom,Cli_AppHom,Cli_ApmHom,Cli_RFC);


		IF( aux = 'BUEI' OR aux = 'BUEY' OR aux = 'CACA' OR aux = 'CACO' OR
			aux = 'CAGA' OR aux = 'CAGO' OR aux = 'CAKA' OR aux = 'CAKO' OR
			aux = 'COGE' OR aux = 'COJA' OR aux = 'KOGE' OR aux = 'KOJO' OR
			aux = 'KAKA' OR aux = 'KULO' OR aux = 'MAME' OR aux = 'MAMO' OR
			aux = 'MEAR' OR aux = 'MEAS' OR aux = 'MEON' OR aux = 'MION' OR
			aux = 'COJE' OR aux = 'COJI' OR aux = 'COJO' OR aux = 'CULO' OR
			aux = 'FETO' OR aux = 'GUEY' OR aux = 'JOTO' OR aux = 'KACA' OR
			aux = 'KACO' OR aux = 'KAGA' OR aux = 'KAGO' OR aux = 'MOCO' OR
			aux = 'MULA' OR aux = 'PEDA' OR aux = 'PEDO' OR aux = 'PENE' OR
			aux = 'PUTA' OR aux = 'PUTO' OR aux = 'QULO' OR aux = 'RATA' OR
			aux = 'RUIN' ) THEN

			SET C_RFC := CONCAT(SUBSTR(C_RFC, 1, 3),'X',SUBSTR(C_RFC, 5, 9));
		END IF;

		SET C_RFC =(RTRIM(C_RFC));
		SET Par_RFC	 = C_RFC;

	END ManejoErrores;

	IF(Par_Salida = Salida_SI)THEN
		SELECT	'00' AS NumErr,
				C_RFC AS Rfc,
				'El RFC se ha Generado Exitosamente' AS ErrMen;
	END IF;

END TerminaStore$$