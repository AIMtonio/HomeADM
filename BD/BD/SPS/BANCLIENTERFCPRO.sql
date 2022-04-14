-- BANCLIENTERFCPRO

DELIMITER ;

DROP PROCEDURE IF EXISTS BANCLIENTERFCPRO;

DELIMITER $$

CREATE PROCEDURE `BANCLIENTERFCPRO`(



	Par_Nombre				VARCHAR(200),
	Par_ApellidoPaterno		VARCHAR(50),
	Par_ApellidoMaterno		VARCHAR(50),
	Par_FechaNacimiento		DATE,
	INOUT Par_RFC			VARCHAR(30),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

    Par_EmpresaID			INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Var_Control			VARCHAR(100);
	DECLARE Var_Consecutivo		VARCHAR(70);
	DECLARE	Var_FechaNac		VARCHAR(10);
	DECLARE	Var_FechaNac2		VARCHAR(10);
	DECLARE	Var_FechaNac3		VARCHAR(10);
	DECLARE	Var_Nombre			VARCHAR(70);
	DECLARE	Var_ApePaterno		VARCHAR(50);
	DECLARE	Var_ApeMaterno		VARCHAR(50);
	DECLARE	Var_Rfc				VARCHAR(13);
	DECLARE	Var_ApeOriginal		VARCHAR(50);
	DECLARE	Var_Auxiliar		VARCHAR(5);
	DECLARE	Var_Indice			INT(11);
	DECLARE	Var_RfcGenerado		VARCHAR(13);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE Salida_Si			CHAR(1);
	DECLARE Salida_No			CHAR(1);
	DECLARE Con_LimpiaCarac1	CHAR(1);
	DECLARE Con_LimpiaCarac2	CHAR(1);
	DECLARE Con_LimpiaCarac3	CHAR(1);
	DECLARE Var_Espacio			VARCHAR(1);
	DECLARE Var_LetraX			CHAR(1);
	DECLARE Var_LetraA			CHAR(1);
	DECLARE Var_LetraE			CHAR(1);
	DECLARE Var_LetraI			CHAR(1);
	DECLARE Var_LetraO			CHAR(1);
	DECLARE Var_LetraU			CHAR(1);
	DECLARE Var_LetraJ			CHAR(2);
	DECLARE Var_SilabaMA		CHAR(3);
	DECLARE Var_PalabraMaria	CHAR(6);
	DECLARE Var_PalabraJose		CHAR(5);

	DECLARE Var_Auxiliar1		CHAR(4);
	DECLARE Var_Auxiliar2		CHAR(4);
	DECLARE Var_Auxiliar3		CHAR(4);
	DECLARE Var_Auxiliar4		CHAR(4);
	DECLARE Var_Auxiliar5		CHAR(4);
	DECLARE Var_Auxiliar6		CHAR(4);
	DECLARE Var_Auxiliar7		CHAR(4);
	DECLARE Var_Auxiliar8		CHAR(4);
	DECLARE Var_Auxiliar9		CHAR(4);
	DECLARE Var_Auxiliar10		CHAR(4);
	DECLARE Var_Auxiliar11		CHAR(4);
	DECLARE Var_Auxiliar12		CHAR(4);
	DECLARE Var_Auxiliar13		CHAR(4);
	DECLARE Var_Auxiliar14		CHAR(4);
	DECLARE Var_Auxiliar15		CHAR(4);
	DECLARE Var_Auxiliar16		CHAR(4);
	DECLARE Var_Auxiliar17		CHAR(4);
	DECLARE Var_Auxiliar18		CHAR(4);
	DECLARE Var_Auxiliar19		CHAR(4);
	DECLARE Var_Auxiliar20		CHAR(4);
	DECLARE Var_Auxiliar21		CHAR(4);
	DECLARE Var_Auxiliar22		CHAR(4);
	DECLARE Var_Auxiliar23		CHAR(4);
	DECLARE Var_Auxiliar24		CHAR(4);
	DECLARE Var_Auxiliar25		CHAR(4);
	DECLARE Var_Auxiliar26		CHAR(4);
	DECLARE Var_Auxiliar27		CHAR(4);
	DECLARE Var_Auxiliar28		CHAR(4);
	DECLARE Var_Auxiliar29		CHAR(4);
	DECLARE Var_Auxiliar30		CHAR(4);
	DECLARE Var_Auxiliar31		CHAR(4);
	DECLARE Var_Auxiliar32		CHAR(4);
	DECLARE Var_Auxiliar33		CHAR(4);
	DECLARE Var_Auxiliar34		CHAR(4);
	DECLARE Var_Auxiliar35		CHAR(4);
	DECLARE Var_Auxiliar36		CHAR(4);
	DECLARE Var_Auxiliar37		CHAR(4);
	DECLARE Var_Auxiliar38		CHAR(4);
	DECLARE Var_Auxiliar39		CHAR(4);
	DECLARE Var_Auxiliar40		CHAR(4);
	DECLARE Var_Auxiliar41		CHAR(4);


	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Salida_Si			:= 'S';
	SET Salida_No			:= 'N';
	SET Con_LimpiaCarac1	:= '1';
	SET Con_LimpiaCarac2	:= '2';
	SET Con_LimpiaCarac3	:= '3';
	SET Var_Espacio			:= ' ';
	SET Var_LetraX			:= 'X';
	SET Var_LetraA			:= 'A';
	SET Var_LetraE			:= 'E';
	SET Var_LetraI			:= 'I';
	SET Var_LetraO			:= 'O';
	SET Var_LetraU			:= 'U';
	SET Var_LetraJ			:= 'J ';
	SET Var_SilabaMA		:= 'MA ';
	SET Var_PalabraMaria	:= 'MARIA ';
	SET Var_PalabraJose		:= 'JOSE ';

	SET Var_Auxiliar1		:= 'BUEI';
	SET Var_Auxiliar2		:= 'CAGA';
	SET Var_Auxiliar3		:= 'COGE';
	SET Var_Auxiliar4		:= 'KAKA';
	SET Var_Auxiliar5		:= 'MEAR';
	SET Var_Auxiliar6		:= 'COJE';
	SET Var_Auxiliar7		:= 'FETO';
	SET Var_Auxiliar8		:= 'KACO';
	SET Var_Auxiliar9		:= 'MULA';
	SET Var_Auxiliar10		:= 'PUTA';
	SET Var_Auxiliar11		:= 'RUIN';
	SET Var_Auxiliar12		:= 'BUEY';
	SET Var_Auxiliar13		:= 'CAGO';
	SET Var_Auxiliar14		:= 'COJA';
	SET Var_Auxiliar15		:= 'KULO';
	SET Var_Auxiliar16		:= 'MEAS';
	SET Var_Auxiliar17		:= 'COJI';
	SET Var_Auxiliar18		:= 'GUEY';
	SET Var_Auxiliar19		:= 'KAGA';
	SET Var_Auxiliar20		:= 'PEDA';
	SET Var_Auxiliar21		:= 'PUTO';
	SET Var_Auxiliar22		:= 'CACA';
	SET Var_Auxiliar23		:= 'CAKA';
	SET Var_Auxiliar24		:= 'KOGE';
	SET Var_Auxiliar25		:= 'MAME';
	SET Var_Auxiliar26		:= 'MEON';
	SET Var_Auxiliar27		:= 'COJO';
	SET Var_Auxiliar28		:= 'JOTO';
	SET Var_Auxiliar29		:= 'KAGO';
	SET Var_Auxiliar30		:= 'PEDO';
	SET Var_Auxiliar31		:= 'QULO';
	SET Var_Auxiliar32		:= 'CACO';
	SET Var_Auxiliar33		:= 'CAKO';
	SET Var_Auxiliar34		:= 'KOJO';
	SET Var_Auxiliar35		:= 'MAMO';
	SET Var_Auxiliar36		:= 'MION';
	SET Var_Auxiliar37		:= 'CULO';
	SET Var_Auxiliar38		:= 'KACA';
	SET Var_Auxiliar39		:= 'MOCO';
	SET Var_Auxiliar40		:= 'PENE';
	SET Var_Auxiliar41		:= 'RATA';



	SET Par_Nombre				:= IFNULL(Par_Nombre,Cadena_Vacia);
	SET Par_ApellidoPaterno		:= IFNULL(Par_ApellidoPaterno,Cadena_Vacia);
	SET Par_ApellidoMaterno		:= IFNULL(Par_ApellidoMaterno,Cadena_Vacia);
	SET Par_FechaNacimiento		:= IFNULL(Par_FechaNacimiento,Fecha_Vacia);

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-BANCLIENTERFCPRO');
			SET Var_Control = 'sqlException' ;
		END;



		IF(Par_Nombre = Cadena_Vacia) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El nombre no puede estar vacio.';
			SET Var_Control	:= 'Par_Nombre';
			LEAVE ManejoErrores;
		END IF;

		IF((Par_ApellidoPaterno = Cadena_Vacia) AND  (Par_ApellidoMaterno = Cadena_Vacia)) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= 'Ambos apellidos no pueden estar vacios.';
			SET Var_Control	:= 'Par_Apellidos';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_FechaNacimiento = Fecha_Vacia) THEN
			SET Par_NumErr	:= 003;
			SET Par_ErrMen	:= 'La fecha no puede estar vacia.';
			SET Var_Control	:= 'Par_FechaNacimiento';
			LEAVE ManejoErrores;
		END IF;



		SET Var_ApeOriginal		:= Par_ApellidoPaterno;

		SET Var_FechaNac		:= SUBSTR(Par_FechaNacimiento,3,2);
		SET Var_FechaNac2		:= SUBSTR(Par_FechaNacimiento,6,2);
		SET Var_FechaNac3		:= SUBSTR(Par_FechaNacimiento,9,2);
		SET Var_FechaNac		:= CONCAT(Var_FechaNac,Var_FechaNac2,Var_FechaNac3);

		SET	Par_Nombre 			:= FNLIMPIACARACTERESPECIAL(Par_Nombre,Con_LimpiaCarac3);
		SET	Par_ApellidoPaterno	:= FNLIMPIACARACTERESPECIAL(Par_ApellidoPaterno,Con_LimpiaCarac3);
		SET	Par_ApellidoMaterno	:= FNLIMPIACARACTERESPECIAL(Par_ApellidoMaterno,Con_LimpiaCarac3);

		SET	Var_Nombre			:= IFNULL(FNLIMPIACARACTERESPECIAL(Par_Nombre,Con_LimpiaCarac1),Cadena_Vacia);
		SET	Var_ApePaterno		:= IFNULL(FNLIMPIACARACTERESPECIAL(Par_ApellidoPaterno,Con_LimpiaCarac1),Cadena_Vacia);
		SET	Var_ApeMaterno		:= IFNULL(FNLIMPIACARACTERESPECIAL(Par_ApellidoMaterno,Con_LimpiaCarac1),Cadena_Vacia);

		SET	Par_Nombre			:= IFNULL(FNLIMPIACARACTERESPECIAL(Var_Nombre,Con_LimpiaCarac2),Cadena_Vacia);
		SET	Par_ApellidoPaterno	:= IFNULL(FNLIMPIACARACTERESPECIAL(Par_ApellidoPaterno,Con_LimpiaCarac2),Cadena_Vacia);
		SET	Par_ApellidoMaterno	:= IFNULL(FNLIMPIACARACTERESPECIAL(Par_ApellidoMaterno,Con_LimpiaCarac2),Cadena_Vacia);

		IF(Par_Nombre <> REPLACE(Par_Nombre, Var_Espacio, Var_LetraX)) THEN
			IF(SUBSTRING(Par_Nombre, 1, 2) = Var_LetraJ)THEN
				SET Par_Nombre	:= SUBSTRING(Par_Nombre, 3, LENGTH(Par_Nombre));
			END IF;
		END IF;

		IF(Par_Nombre <> REPLACE(Par_Nombre,Var_Espacio, Var_LetraX)) THEN
			IF(SUBSTRING(Par_Nombre, 1, 3) = Var_SilabaMA)THEN
				SET Par_Nombre	:= SUBSTRING(Par_Nombre, 4, LENGTH(Par_Nombre));
			END IF;
		END IF;

		IF(Par_Nombre <> REPLACE(Par_Nombre, Var_Espacio, Var_LetraX)) THEN
			IF(SUBSTRING(Par_Nombre, 1, 5) = Var_PalabraJose)THEN
				SET Par_Nombre	:= SUBSTRING(Par_Nombre, 6, LENGTH(Par_Nombre));
			END IF;
		END IF;

		IF(Par_Nombre <> REPLACE(Par_Nombre,Var_Espacio, Var_LetraX)) THEN
			IF(SUBSTRING(Par_Nombre, 1, 6) = Var_PalabraMaria)THEN
				SET	Par_Nombre	:= SUBSTRING(Par_Nombre, 7, LENGTH(Par_Nombre));
			END IF;
		END IF;

		SET Var_Rfc	:= Cadena_Vacia;

		IF((Par_ApellidoMaterno = Cadena_Vacia) OR (Par_ApellidoPaterno = Cadena_Vacia)) THEN
			IF(Par_ApellidoPaterno = Cadena_Vacia)THEN
				SET Par_ApellidoPaterno := Par_ApellidoMaterno;
				IF(LENGTH(Par_ApellidoPaterno) < 2) THEN
					SET Var_Rfc		:= CONCAT(SUBSTR(Par_ApellidoPaterno,1,1),SUBSTR(Par_Nombre,1,2));
					IF(CHARINDEX(Var_Espacio, Par_Nombre) > 0) THEN
						SET Var_Rfc	:= CONCAT(LTRIM(Var_Rfc),SUBSTR(Par_Nombre, CHARINDEX(Var_Espacio, Par_Nombre)+1, 1));
					ELSE
						SET Var_Rfc	:= CONCAT(LTRIM(Var_Rfc),Var_LetraX);
					END IF;
				ELSE
					SET Var_Rfc	:= CONCAT(SUBSTR(Par_ApellidoPaterno,1,2),SUBSTR(Par_Nombre,1,2));
				END IF;
			END IF;
		END IF;

		IF(Par_ApellidoMaterno != Cadena_Vacia) THEN
			IF(LENGTH(LTRIM(RTRIM(Var_ApeOriginal))) <= 3) THEN
				SET Var_Rfc		:= CONCAT(SUBSTR(Par_ApellidoPaterno,1,1),SUBSTR(Par_ApellidoMaterno,1,1),SUBSTR(Par_Nombre,1,2));
			ELSE
				SET Var_Rfc		:= SUBSTR(Par_ApellidoPaterno,1,1);
				SET Var_Indice	:= 2;
				WHILE Var_Indice <= LENGTH(Par_ApellidoPaterno) DO
					SET Var_Auxiliar	:= SUBSTR(Par_ApellidoPaterno,Var_Indice,1);
					IF((Var_Auxiliar = Var_LetraA) OR (Var_Auxiliar = Var_LetraE) OR (Var_Auxiliar = Var_LetraI) OR (Var_Auxiliar = Var_LetraO) OR (Var_Auxiliar = Var_LetraU)) THEN
						SET Var_Rfc		:= CONCAT(RTRIM(Var_Rfc),SUBSTR(Par_ApellidoPaterno,Var_Indice,1));
						SET Var_Indice	:= LENGTH(RTRIM(Par_ApellidoPaterno));
					END IF;
					SET Var_Indice	:= Var_Indice + 1;
				END WHILE;
				SET Var_Rfc	:= CONCAT(RTRIM(Var_Rfc),SUBSTR(Par_ApellidoMaterno,1,1),SUBSTR(Par_Nombre,1,1));
			END IF;
		END IF;

		IF(Par_ApellidoMaterno = Cadena_Vacia) THEN
			IF(LENGTH(LTRIM(RTRIM(Var_ApeOriginal))) <= 3) THEN
				SET Var_Rfc	:= CONCAT(SUBSTR(Par_ApellidoPaterno,1,2),SUBSTR(Par_ApellidoMaterno,1,1),SUBSTR(Par_Nombre,1,2));
			ELSE
				SET Var_Rfc		:= SUBSTR(Par_ApellidoPaterno,1,1);
				SET Var_Indice	:=2;
				WHILE Var_Indice <= LENGTH(Par_ApellidoPaterno) DO
					SET Var_Auxiliar	:= SUBSTR(Par_ApellidoPaterno,Var_Indice,1);
					IF((Var_Auxiliar = Var_LetraA) OR (Var_Auxiliar = Var_LetraE) OR (Var_Auxiliar = Var_LetraI) OR (Var_Auxiliar = Var_LetraO) OR (Var_Auxiliar = Var_LetraU)) THEN
						SET Var_Rfc		:= CONCAT(RTRIM(Var_Rfc),SUBSTR(Par_ApellidoPaterno,Var_Indice,1));
						SET Var_Indice	:= LENGTH(RTRIM(Par_ApellidoPaterno));
					END IF;
					SET Var_Indice	:= Var_Indice + 1;
				END WHILE;
				SET Var_Rfc	:= CONCAT(RTRIM(Var_Rfc),SUBSTR(Par_ApellidoMaterno,1,1),SUBSTR(Par_Nombre,1,2));
			END IF;
		END IF;

		SET Var_Auxiliar 		:= RTRIM(Var_Rfc);
		SET Var_Rfc 			:= CONCAT(RTRIM(Var_Rfc),RTRIM(Var_FechaNac));
		SET Var_RfcGenerado 	:= FNRFCGENHOMOCAL(Var_Nombre,Var_ApePaterno,Var_ApeMaterno,Var_Rfc);

		IF(Var_Auxiliar = Var_Auxiliar1  OR Var_Auxiliar = Var_Auxiliar12 OR Var_Auxiliar = Var_Auxiliar22 OR Var_Auxiliar = Var_Auxiliar32 OR
		   Var_Auxiliar = Var_Auxiliar2  OR Var_Auxiliar = Var_Auxiliar13 OR Var_Auxiliar = Var_Auxiliar23 OR Var_Auxiliar = Var_Auxiliar33 OR
		   Var_Auxiliar = Var_Auxiliar3  OR Var_Auxiliar = Var_Auxiliar14 OR Var_Auxiliar = Var_Auxiliar24 OR Var_Auxiliar = Var_Auxiliar34 OR
		   Var_Auxiliar = Var_Auxiliar4  OR Var_Auxiliar = Var_Auxiliar15 OR Var_Auxiliar = Var_Auxiliar25 OR Var_Auxiliar = Var_Auxiliar35 OR
		   Var_Auxiliar = Var_Auxiliar5  OR Var_Auxiliar = Var_Auxiliar16 OR Var_Auxiliar = Var_Auxiliar26 OR Var_Auxiliar = Var_Auxiliar36 OR
		   Var_Auxiliar = Var_Auxiliar6  OR Var_Auxiliar = Var_Auxiliar17 OR Var_Auxiliar = Var_Auxiliar27 OR Var_Auxiliar = Var_Auxiliar37 OR
		   Var_Auxiliar = Var_Auxiliar7  OR Var_Auxiliar = Var_Auxiliar18 OR Var_Auxiliar = Var_Auxiliar28 OR Var_Auxiliar = Var_Auxiliar38 OR
		   Var_Auxiliar = Var_Auxiliar8  OR Var_Auxiliar = Var_Auxiliar19 OR Var_Auxiliar = Var_Auxiliar29 OR Var_Auxiliar = Var_Auxiliar39 OR
		   Var_Auxiliar = Var_Auxiliar9  OR Var_Auxiliar = Var_Auxiliar20 OR Var_Auxiliar = Var_Auxiliar30 OR Var_Auxiliar = Var_Auxiliar40 OR
		   Var_Auxiliar = Var_Auxiliar10 OR Var_Auxiliar = Var_Auxiliar21 OR Var_Auxiliar = Var_Auxiliar31 OR Var_Auxiliar = Var_Auxiliar41 OR
		   Var_Auxiliar = Var_Auxiliar11) THEN
			SET Var_RfcGenerado	:= CONCAT(SUBSTR(Var_RfcGenerado, 1, 3),Var_LetraX,SUBSTR(Var_RfcGenerado, 5, 9));
		END IF;


		SET Par_RFC			:= (RTRIM(Var_RfcGenerado));
		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'RFC generado exitosamente.';
		SET Var_Control		:= Par_RFC;

	END ManejoErrores;


	IF (Par_Salida = Salida_Si) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;


END TerminaStore$$
