-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUSCACOINCIDENCIASPLD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUSCACOINCIDENCIASPLD`;DELIMITER $$

CREATE PROCEDURE `BUSCACOINCIDENCIASPLD`(
	Par_ClavePersonaID		INT(11),
	Par_TipoPersSAFI		VARCHAR(3),
	Par_PrimerNombre		VARCHAR(100),			-- Primer Nombre
	Par_SegundoNombre		VARCHAR(100),			-- Segundo Nombre
	Par_TercerNombre		VARCHAR(100),			-- Tercer Nombre
	Par_ApePaterno			VARCHAR(100),			-- Apellido Paterno
	Par_ApeMaterno			VARCHAR(100),			-- Apellido Materno

	Par_RazonSocial			VARCHAR(200),			-- Razon Social para personas morales
	Par_Porcentaje			INT(11),				-- Porcentaje para conciderar como coincidencia para PLD
	Par_Lista				INT(11),
	Par_Salida				CHAR(1),				-- Parametro de salida
	INOUT Par_NumErr		INT(11),				-- Parametro del numero de Error
	INOUT Par_ErrMen		VARCHAR(300),			-- Parametro del Mensaje de Error

	Par_EmpresaID			INT,				    -- Parametro de Auditoria
	Aud_Usuario         	INT,					-- Parametro de Auditoria
	Aud_FechaActual     	DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP     	VARCHAR(15),			-- Parametro de Auditoria

	Aud_ProgramaID      	VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal        	INT,					-- Parametro de Auditoria
	Aud_NumTransaccion  	BIGINT					-- Parametro de Auditoria
)
TerminaStored:BEGIN
-- Declaracion de Variables
DECLARE	Var_ListaNegraID	INT(11);
DECLARE	Var_PersonaBloqID	INT(11);
DECLARE Var_PrimNom			VARCHAR(100);
DECLARE Var_SegNom			VARCHAR(100);
DECLARE Var_TerNom			VARCHAR(100);
DECLARE Var_ApPaterno		VARCHAR(100);
DECLARE Var_ApMaterno		VARCHAR(100);
DECLARE Var_RazonSoc		VARCHAR(200);
DECLARE Var_TipoPersona 	CHAR(1);
DECLARE Var_NomCompleto		VARCHAR(400);

DECLARE Var_PrimNomOrig			VARCHAR(100);
DECLARE Var_SegNomOrig			VARCHAR(100);
DECLARE Var_TerNomOrig			VARCHAR(100);
DECLARE Var_ApPaternoOrig		VARCHAR(100);
DECLARE Var_ApMaternoOrig		VARCHAR(100);
DECLARE Var_RazonSocOrig		VARCHAR(200);

DECLARE Var_Control				VARCHAR(50);

DECLARE LongPrimNom			INT(11);
DECLARE LongSegNom			INT(11);
DECLARE LongTerNom			INT(11);
DECLARE LongApPat			INT(11);
DECLARE LongApMat			INT(11);
DECLARE LongRazSoc			INT(11);

DECLARE LongPrimNomAux		INT(11);
DECLARE LongSegNomAux		INT(11);
DECLARE LongTerNomAux		INT(11);
DECLARE LongApPatAux		INT(11);
DECLARE LongApMatAux		INT(11);
DECLARE LongRazSocAux		INT(11);
DECLARE ContadorX			INT(11);
DECLARE ContadorY			INT(11);
DECLARE Bandera				INT(11);
DECLARE CarOriginal			CHAR(1);
DECLARE CarCompara			CHAR(1);
DECLARE Coincidencia1		INT(11);
DECLARE Auxiliar1			DECIMAL(10,2);

DECLARE Coincidencia2		INT(11);
DECLARE Auxiliar2			DECIMAL(10,2);

DECLARE Coincidencia3		INT(11);
DECLARE Auxiliar3			DECIMAL(10,2);

DECLARE Coincidencia4		INT(11);
DECLARE Auxiliar4			DECIMAL(10,2);

DECLARE Coincidencia5		INT(11);
DECLARE Auxiliar5			DECIMAL(10,2);

DECLARE Coincidencia6		INT(11);
DECLARE Auxiliar6			DECIMAL(10,2);

DECLARE NuvaCadena			VARCHAR(200);
DECLARE TmpLogitud			INT(11);

DECLARE TotalCaract			INT(11);
DECLARE Porcentaje1			DECIMAL(10,2);
DECLARE Porcentaje2			DECIMAL(10,2);
DECLARE Porcentaje3			DECIMAL(10,2);
DECLARE Porcentaje4			DECIMAL(10,2);
DECLARE Porcentaje5			DECIMAL(10,2);
DECLARE Porcentaje6			DECIMAL(10,2);
DECLARE PorcentajeTotal		DECIMAL(10,2);
DECLARE TotalNombres		INT(11);
DECLARE Indice				INT(11);


/*Declaracion de Constantes*/
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Entero_Cero		INT(11);
DECLARE Entero_Uno		INT(11);
DECLARE Entero_Cien		INT(11);
DECLARE Salida_SI		CHAR(1);





	DECLARE CursorLisNegras CURSOR FOR
	SELECT ListaNegraID,	PrimerNombre,SegundoNombre,TercerNombre,ApellidoPaterno,ApellidoMaterno, RazonSocial, TipoPersona
	FROM PLDLISTANEGRAS;

	DECLARE CursorPersonasBloq CURSOR FOR
	SELECT PersonaBloqID, PrimerNombre,SegundoNombre,TercerNombre,ApellidoPaterno,ApellidoMaterno, RazonSocial , TipoPersona
	FROM PLDLISTAPERSBLOQ;


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr   := 999;
		SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			'esto le ocasiona. Ref: SP-BUSCACOINCIDENCIASPLD');
		SET Var_Control  := 'SQLEXCEPTION';
	END;


	SET Par_PrimerNombre := TRIM(IFNULL(Par_PrimerNombre,Cadena_Vacia));
	SET Par_SegundoNombre := TRIM(IFNULL(Par_SegundoNombre,Cadena_Vacia));
	SET Par_TercerNombre := TRIM(IFNULL(Par_TercerNombre,Cadena_Vacia));
	SET Par_ApePaterno	:= TRIM(IFNULL(Par_ApePaterno,Cadena_Vacia));
	SET Par_ApeMaterno	:= TRIM(IFNULL(Par_ApeMaterno,Cadena_Vacia));
	SET Par_RazonSocial	:= TRIM(IFNULL(Par_RazonSocial,Cadena_Vacia));


	SET LongPrimNom	:=	LENGTH(Par_PrimerNombre);
	SET LongSegNom  := 	LENGTH(Par_SegundoNombre);
	SET LongTerNom  := 	LENGTH(Par_TercerNombre);
	SET LongApPat   := 	LENGTH(Par_ApePaterno);
	SET LongApMat   := 	LENGTH(Par_ApeMaterno);
	SET LongRazSoc	:=	LENGTH(Par_RazonSocial);




	SET Auxiliar1 := 0;
	SET Coincidencia1 := 0;
	SET Auxiliar2 := 0;
	SET Coincidencia2 := 0;
	SET Auxiliar3 := 0;
	SET Coincidencia3 := 0;
	SET Auxiliar4 := 0;
	SET Coincidencia4 := 0;
	SET Auxiliar5 := 0;
	SET Coincidencia5:= 0;
	SET Auxiliar6 := 0;
	SET Coincidencia6:= 0;


	SET Porcentaje1	:= 0;
	SET Porcentaje2	:= 0;
	SET Porcentaje3	:= 0;
	SET Porcentaje4	:= 0;
	SET Porcentaje5	:= 0;
	SET Porcentaje6	:= 0;

	SET Cadena_Vacia :='';
	SET Entero_Cero  := 0;
	SET Entero_Uno := 1;
	SET Entero_Cien := 100;
	SET ContadorX	:=1;
	SET ContadorY	:=1;
	SET TotalNombres := 0;
	SET Salida_SI	:= 'S';
	/*Aplicando metodo de Similar a burbuja para coincidencias*/

	IF(Par_Lista = 1) THEN
		-- Cursor para encontrar las coincidencias dentro de la tabla LISTASNEGRAS
		OPEN CursorLisNegras;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CursorLisNegras INTO Var_ListaNegraID,Var_PrimNom,Var_SegNom,Var_TerNom,Var_ApPaterno,Var_ApMaterno,Var_RazonSoc,Var_TipoPersona;

						IF(IFNULL(Var_PrimNom,Cadena_Vacia) != Cadena_Vacia) THEN
							-- limpieza de espacios al principio y al final
							SET Var_PrimNom		:=		TRIM(IFNULL(Var_PrimNom,Cadena_Vacia));
							SET Var_SegNom		:= 		TRIM(IFNULL(Var_SegNom,Cadena_Vacia));
							SET Var_TerNom		:= 		TRIM(IFNULL(Var_TerNom,Cadena_Vacia));
							SET Var_ApPaterno 	:= 		TRIM(IFNULL(Var_ApPaterno,Cadena_Vacia));
							SET Var_ApMaterno 	:= 		TRIM(IFNULL(Var_ApMaterno,Cadena_Vacia));

							SET Var_PrimNomOrig		:=		Var_PrimNom;
							SET Var_SegNomOrig		:= 		Var_SegNom;
							SET Var_TerNomOrig		:= 		Var_TerNom;
							SET Var_ApPaternoOrig 	:= 		Var_ApPaterno;
							SET Var_ApMaternoOrig 	:= 		Var_ApMaterno;
							-- obtenemos el numero de caracteres por cadena

							SET LongSegNomAux	:=	LENGTH(Var_SegNom);
							SET LongTerNomAux 	:=	LENGTH(Var_TerNom);
							SET LongApPatAux	:=	LENGTH(Var_ApPaterno);
							SET LongApMatAux	:=	LENGTH(Var_ApMaterno);

							SET TmpLogitud	:=	LENGTH(Var_PrimNom);
							-- primer ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia1	:= Entero_Cero;

							SET TotalNombres := Entero_Cero;
							SET PorcentajeTotal := Entero_Cero;
							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							SET Porcentaje1 := Entero_Cero;
							SET Porcentaje2 := Entero_Cero;
							SET Porcentaje3 := Entero_Cero;
							SET Porcentaje4 := Entero_Cero;
							SET Porcentaje5 := Entero_Cero;


							WHILE(ContadorX <= LongPrimNom) DO
								SET CarOriginal :=SUBSTRING(Par_PrimerNombre,ContadorX,Entero_Uno);
								SET LongPrimNomAux 	:=	LENGTH(Var_PrimNom);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;

								WHILE (ContadorY <= LongPrimNomAux) DO


									SET CarCompara	:=	SUBSTRING(Var_PrimNom,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia1 := Coincidencia1 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_PrimNom,(ContadorY+Entero_Uno),LongPrimNomAux));
										SET ContadorY	:=	LongPrimNomAux;

									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);

									END IF;

									IF(ContadorY = LongPrimNomAux)THEN
											SET Var_PrimNom := NuvaCadena;
											SET LongPrimNomAux := LENGTH(Var_PrimNom);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongPrimNomAux := LENGTH(Var_PrimNom);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongPrimNom = Coincidencia1) THEN

								SET Auxiliar1 :=	(Coincidencia1 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar1 :=	(Coincidencia1 * Entero_Cien) / LongPrimNom;
							END IF;


							IF (Porcentaje1 < Auxiliar1)THEN
								SET Porcentaje1 := Auxiliar1;
							END IF;
							-- Fin Seccion Primer Nombre

							-- Seccion de Segundo nombre
							SET TmpLogitud	:=	LENGTH(Var_SegNom);
							  -- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia2	:= Entero_Cero;
							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongSegNom) DO
								SET CarOriginal :=SUBSTRING(Par_SegundoNombre,ContadorX,Entero_Uno);


								SET LongSegNomAux 	:=	LENGTH(Var_SegNom);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongSegNomAux) DO


									SET CarCompara	:=	SUBSTRING(Var_SegNom,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia2 := Coincidencia2 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_SegNom,(ContadorY+Entero_Uno),LongSegNomAux));
										SET ContadorY	:=	LongSegNomAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									IF(ContadorY = LongSegNomAux)THEN
											SET Var_SegNom := NuvaCadena;
											SET LongSegNomAux := LENGTH(Var_SegNom);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongSegNomAux := LENGTH(Var_SegNom);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongSegNom = Coincidencia2) THEN

								SET Auxiliar2 :=	(Coincidencia2 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar2 :=	(Coincidencia2 * Entero_Cien) / LongSegNom;
							END IF;


							IF (Porcentaje2 < Auxiliar2)THEN
								SET Porcentaje2 := Auxiliar2;
							END IF;
							-- Fin Seccion segundo nombre

							-- Inicio Seccion Tercer Nombre
							SET TmpLogitud	:=	LENGTH(Var_TerNom);
							-- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia3	:= Entero_Cero;
							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongTerNom) DO
								SET CarOriginal :=SUBSTRING(Par_TercerNombre,ContadorX,Entero_Uno);


								SET LongTerNomAux 	:=	LENGTH(Var_TerNom);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongTerNomAux) DO


									SET CarCompara	:=	SUBSTRING(Var_TerNom,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia3 := Coincidencia3 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_TerNom,(ContadorY+Entero_Uno),LongTerNomAux));
										SET ContadorY	:=	LongTerNomAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									 IF(ContadorY = LongTerNomAux)THEN
											SET Var_TerNom := NuvaCadena;
											SET LongTerNomAux := LENGTH(Var_TerNom);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongTerNomAux := LENGTH(Var_TerNom);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongTerNom = Coincidencia3) THEN

								SET Auxiliar3 :=	(Coincidencia3 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar3 :=	(Coincidencia3 * Entero_Cien) / LongTerNom;
							END IF;


							IF (Porcentaje3 < Auxiliar3)THEN
								SET Porcentaje3 := Auxiliar3;
							END IF;
							-- Fin Seccion Tercer Nombre


							-- Inicio Seccion Apellido paterno
							SET TmpLogitud	:=	LENGTH(Var_ApPaterno);
							-- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia4	:= Entero_Cero;

							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongApPat) DO
								SET CarOriginal :=SUBSTRING(Par_ApePaterno,ContadorX,Entero_Uno);
								SET LongApPatAux 	:=	LENGTH(Var_ApPaterno);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongApPatAux) DO


									SET CarCompara	:=	SUBSTRING(Var_ApPaterno,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia4 := Coincidencia4 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_ApPaterno,(ContadorY+Entero_Uno),LongApPatAux));
										SET ContadorY	:=	LongApPatAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);

									END IF;

									IF(ContadorY = LongApPatAux)THEN
											SET Var_ApPaterno := NuvaCadena;
											SET LongApPatAux := LENGTH(Var_ApPaterno);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongApPatAux := LENGTH(Var_ApPaterno);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;



							IF (LongApPat = Coincidencia4) THEN

								SET Auxiliar4 :=	(Coincidencia4 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar4 :=	(Coincidencia4 * Entero_Cien) / LongApPat;
							END IF;


							IF (Porcentaje4 < Auxiliar4)THEN
								SET Porcentaje4 := Auxiliar4;
							END IF;
							-- Fin Seccion Apellido Paterno




							-- Inicio seccion Apellido Materno
							SET TmpLogitud	:=	LENGTH(Var_ApMaterno);
							-- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia5	:= Entero_Cero;

							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongApMat) DO
								SET CarOriginal :=SUBSTRING(Par_ApeMaterno,ContadorX,Entero_Uno);


								SET LongApMatAux 	:=	LENGTH(Var_ApMaterno);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongApMatAux) DO


									SET CarCompara	:=	SUBSTRING(Var_ApMaterno,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia5 := Coincidencia5 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_ApMaterno,(ContadorY+Entero_Uno),LongApMatAux));
										SET ContadorY	:=	LongApMatAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									IF(ContadorY = LongApMatAux)THEN
											SET Var_ApMaterno := NuvaCadena;
											SET LongApMatAux := LENGTH(Var_ApMaterno);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongApMatAux := LENGTH(Var_ApMaterno);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongApMat = Coincidencia5) THEN

								SET Auxiliar5 :=	(Coincidencia5 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar5 :=	(Coincidencia5 * Entero_Cien) / LongApMat;
							END IF;


							IF (Porcentaje5 < Auxiliar5)THEN
								SET Porcentaje5 := Auxiliar5;
							END IF;
							-- Fin Seccion Apellido Materno
							-- Fin de la seccion SI para Personas Fisicas o Fisicas con Actividad Empresarial
						ELSE
							-- Inicio para seccion de Personas Morales
							SET Var_RazonSoc 	:= 		TRIM(IFNULL(Var_RazonSoc,Cadena_Vacia));
							SET Var_RazonSocOrig 	:= 		Var_RazonSoc;
							SET Porcentaje6 := Entero_Cero;
							SET TotalNombres := Entero_Cero;
							-- obtenemos el numero de caracteres por cadena

							SET LongRazSoc	:=	LENGTH(Var_RazonSoc);

							SET TmpLogitud	:=	LENGTH(Var_RazonSoc);
							-- primer ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia6	:= Entero_Cero;

							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongRazSoc) DO
								SET CarOriginal :=SUBSTRING(Par_RazonSocial,ContadorX,Entero_Uno);


								SET LongRazSocAux 	:=	LENGTH(Var_RazonSoc);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongRazSocAux) DO
									SET CarCompara	:=	SUBSTRING(Var_RazonSoc,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia6 := Coincidencia6 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_RazonSoc,(ContadorY+Entero_Uno),LongRazSocAux));
										SET ContadorY	:=	LongRazSocAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									 IF(ContadorY = LongRazSocAux)THEN
											SET Var_RazonSoc := NuvaCadena;
											SET LongRazSocAux := LENGTH(Var_RazonSoc);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongRazSocAux := LENGTH(Var_RazonSoc);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongRazSoc = Coincidencia6) THEN

								SET Auxiliar6 :=	(Coincidencia6 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar6 :=	(Coincidencia6 * Entero_Cien) / LongRazSoc;
							END IF;


							IF (Porcentaje6 < Auxiliar6)THEN
								SET Porcentaje6 := Auxiliar6;
							END IF;
							-- Fin seccion para personas Morales
						END IF;
						-- Fin de la concicion para comparar los nombres
						IF(IFNULL(Par_PrimerNombre,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_SegundoNombre,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_TercerNombre,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_ApePaterno,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_ApeMaterno,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_RazonSocial,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;

						SET PorcentajeTotal :=	(Porcentaje1 + Porcentaje2 + Porcentaje3 + Porcentaje4 + Porcentaje5 + Porcentaje6)/TotalNombres;


					IF(PorcentajeTotal >= Par_Porcentaje)THEN
						SELECT IFNULL(MAX(CoincidenciaID),Entero_Cero)+ Entero_Uno
						INTO Indice FROM `TMPCOINCIDENCIASPLD`;

						INSERT INTO `TMPCOINCIDENCIASPLD`(
							`CoincidenciaID`,		`ClavePersonaID`,		ListaNegraID,			`TipoPersSAFI`,		`Coincidencia`, 	`NumTransaccion`)
						  VALUES(
							Indice,					Par_ClavePersonaID,		Var_ListaNegraID,		Par_TipoPersSAFI,	PorcentajeTotal,	Aud_NumTransaccion);
					END IF;
				END LOOP;
			END;
		CLOSE CursorLisNegras;
	END IF;

	IF(Par_Lista = 2) THEN
		-- Cursor para encontrar las coincidencias dentro de la tabla LISTASNEGRAS
		OPEN CursorLisNegras;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				LOOP
					FETCH CursorLisNegras INTO Var_PersonaBloqID,Var_PrimNom,Var_SegNom,Var_TerNom,Var_ApPaterno,Var_ApMaterno,Var_RazonSoc,Var_TipoPersona;

						IF(IFNULL(Var_PrimNom,Cadena_Vacia) != Cadena_Vacia) THEN
							-- limpieza de espacios al principio y al final
							SET Var_PrimNom		:=		TRIM(IFNULL(Var_PrimNom,Cadena_Vacia));
							SET Var_SegNom		:= 		TRIM(IFNULL(Var_SegNom,Cadena_Vacia));
							SET Var_TerNom		:= 		TRIM(IFNULL(Var_TerNom,Cadena_Vacia));
							SET Var_ApPaterno 	:= 		TRIM(IFNULL(Var_ApPaterno,Cadena_Vacia));
							SET Var_ApMaterno 	:= 		TRIM(IFNULL(Var_ApMaterno,Cadena_Vacia));

							SET Var_PrimNomOrig		:=		Var_PrimNom;
							SET Var_SegNomOrig		:= 		Var_SegNom;
							SET Var_TerNomOrig		:= 		Var_TerNom;
							SET Var_ApPaternoOrig 	:= 		Var_ApPaterno;
							SET Var_ApMaternoOrig 	:= 		Var_ApMaterno;
							-- obtenemos el numero de caracteres por cadena

							SET LongSegNomAux	:=	LENGTH(Var_SegNom);
							SET LongTerNomAux 	:=	LENGTH(Var_TerNom);
							SET LongApPatAux	:=	LENGTH(Var_ApPaterno);
							SET LongApMatAux	:=	LENGTH(Var_ApMaterno);

							SET TmpLogitud	:=	LENGTH(Var_PrimNom);
							-- primer ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia1	:= Entero_Cero;

							SET TotalNombres := Entero_Cero;
							SET PorcentajeTotal := Entero_Cero;
							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							SET Porcentaje1 := Entero_Cero;
							SET Porcentaje2 := Entero_Cero;
							SET Porcentaje3 := Entero_Cero;
							SET Porcentaje4 := Entero_Cero;
							SET Porcentaje5 := Entero_Cero;


							WHILE(ContadorX <= LongPrimNom) DO
								SET CarOriginal :=SUBSTRING(Par_PrimerNombre,ContadorX,Entero_Uno);
								SET LongPrimNomAux 	:=	LENGTH(Var_PrimNom);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;

								WHILE (ContadorY <= LongPrimNomAux) DO


									SET CarCompara	:=	SUBSTRING(Var_PrimNom,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia1 := Coincidencia1 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_PrimNom,(ContadorY+Entero_Uno),LongPrimNomAux));
										SET ContadorY	:=	LongPrimNomAux;

									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);

									END IF;

									IF(ContadorY = LongPrimNomAux)THEN
											SET Var_PrimNom := NuvaCadena;
											SET LongPrimNomAux := LENGTH(Var_PrimNom);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongPrimNomAux := LENGTH(Var_PrimNom);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongPrimNom = Coincidencia1) THEN

								SET Auxiliar1 :=	(Coincidencia1 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar1 :=	(Coincidencia1 * Entero_Cien) / LongPrimNom;
							END IF;


							IF (Porcentaje1 < Auxiliar1)THEN
								SET Porcentaje1 := Auxiliar1;
							END IF;
							-- Fin Seccion Primer Nombre

							-- Seccion de Segundo nombre
							SET TmpLogitud	:=	LENGTH(Var_SegNom);
							  -- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia2	:= Entero_Cero;
							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongSegNom) DO
								SET CarOriginal :=SUBSTRING(Par_SegundoNombre,ContadorX,Entero_Uno);


								SET LongSegNomAux 	:=	LENGTH(Var_SegNom);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongSegNomAux) DO


									SET CarCompara	:=	SUBSTRING(Var_SegNom,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia2 := Coincidencia2 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_SegNom,(ContadorY+Entero_Uno),LongSegNomAux));
										SET ContadorY	:=	LongSegNomAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									IF(ContadorY = LongSegNomAux)THEN
											SET Var_SegNom := NuvaCadena;
											SET LongSegNomAux := LENGTH(Var_SegNom);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongSegNomAux := LENGTH(Var_SegNom);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongSegNom = Coincidencia2) THEN

								SET Auxiliar2 :=	(Coincidencia2 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar2 :=	(Coincidencia2 * Entero_Cien) / LongSegNom;
							END IF;


							IF (Porcentaje2 < Auxiliar2)THEN
								SET Porcentaje2 := Auxiliar2;
							END IF;
							-- Fin Seccion segundo nombre

							-- Inicio Seccion Tercer Nombre
							SET TmpLogitud	:=	LENGTH(Var_TerNom);
							-- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia3	:= Entero_Cero;
							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongTerNom) DO
								SET CarOriginal :=SUBSTRING(Par_TercerNombre,ContadorX,Entero_Uno);


								SET LongTerNomAux 	:=	LENGTH(Var_TerNom);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongTerNomAux) DO


									SET CarCompara	:=	SUBSTRING(Var_TerNom,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia3 := Coincidencia3 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_TerNom,(ContadorY+Entero_Uno),LongTerNomAux));
										SET ContadorY	:=	LongTerNomAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									 IF(ContadorY = LongTerNomAux)THEN
											SET Var_TerNom := NuvaCadena;
											SET LongTerNomAux := LENGTH(Var_TerNom);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongTerNomAux := LENGTH(Var_TerNom);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongTerNom = Coincidencia3) THEN

								SET Auxiliar3 :=	(Coincidencia3 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar3 :=	(Coincidencia3 * Entero_Cien) / LongTerNom;
							END IF;


							IF (Porcentaje3 < Auxiliar3)THEN
								SET Porcentaje3 := Auxiliar3;
							END IF;
							-- Fin Seccion Tercer Nombre


							-- Inicio Seccion Apellido paterno
							SET TmpLogitud	:=	LENGTH(Var_ApPaterno);
							-- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia4	:= Entero_Cero;

							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongApPat) DO
								SET CarOriginal :=SUBSTRING(Par_ApePaterno,ContadorX,Entero_Uno);
								SET LongApPatAux 	:=	LENGTH(Var_ApPaterno);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongApPatAux) DO


									SET CarCompara	:=	SUBSTRING(Var_ApPaterno,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia4 := Coincidencia4 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_ApPaterno,(ContadorY+Entero_Uno),LongApPatAux));
										SET ContadorY	:=	LongApPatAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);

									END IF;

									IF(ContadorY = LongApPatAux)THEN
											SET Var_ApPaterno := NuvaCadena;
											SET LongApPatAux := LENGTH(Var_ApPaterno);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongApPatAux := LENGTH(Var_ApPaterno);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;



							IF (LongApPat = Coincidencia4) THEN

								SET Auxiliar4 :=	(Coincidencia4 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar4 :=	(Coincidencia4 * Entero_Cien) / LongApPat;
							END IF;


							IF (Porcentaje4 < Auxiliar4)THEN
								SET Porcentaje4 := Auxiliar4;
							END IF;
							-- Fin Seccion Apellido Paterno




							-- Inicio seccion Apellido Materno
							SET TmpLogitud	:=	LENGTH(Var_ApMaterno);
							-- priner ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia5	:= Entero_Cero;

							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongApMat) DO
								SET CarOriginal :=SUBSTRING(Par_ApeMaterno,ContadorX,Entero_Uno);


								SET LongApMatAux 	:=	LENGTH(Var_ApMaterno);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongApMatAux) DO


									SET CarCompara	:=	SUBSTRING(Var_ApMaterno,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia5 := Coincidencia5 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_ApMaterno,(ContadorY+Entero_Uno),LongApMatAux));
										SET ContadorY	:=	LongApMatAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									IF(ContadorY = LongApMatAux)THEN
											SET Var_ApMaterno := NuvaCadena;
											SET LongApMatAux := LENGTH(Var_ApMaterno);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongApMatAux := LENGTH(Var_ApMaterno);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongApMat = Coincidencia5) THEN

								SET Auxiliar5 :=	(Coincidencia5 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar5 :=	(Coincidencia5 * Entero_Cien) / LongApMat;
							END IF;


							IF (Porcentaje5 < Auxiliar5)THEN
								SET Porcentaje5 := Auxiliar5;
							END IF;
							-- Fin Seccion Apellido Materno
							-- Fin de la seccion SI para Personas Fisicas o Fisicas con Actividad Empresarial
						ELSE
							-- Inicio para seccion de Personas Morales
							SET Var_RazonSoc 	:= 		TRIM(IFNULL(Var_RazonSoc,Cadena_Vacia));
							SET Var_RazonSocOrig 	:= 		Var_RazonSoc;
							SET Porcentaje6 := Entero_Cero;
							SET TotalNombres := Entero_Cero;
							-- obtenemos el numero de caracteres por cadena

							SET LongRazSoc	:=	LENGTH(Var_RazonSoc);

							SET TmpLogitud	:=	LENGTH(Var_RazonSoc);
							-- primer ciclo para obtenre el caracter del nombre a buscar
							SET Coincidencia6	:= Entero_Cero;

							SET ContadorX := Entero_Uno;
							SET NuvaCadena	:=	Cadena_Vacia;
							WHILE(ContadorX <= LongRazSoc) DO
								SET CarOriginal :=SUBSTRING(Par_RazonSocial,ContadorX,Entero_Uno);


								SET LongRazSocAux 	:=	LENGTH(Var_RazonSoc);
								SET NuvaCadena	:=	Cadena_Vacia;

								SET ContadorY := Entero_Uno;
								WHILE (ContadorY <= LongRazSocAux) DO
									SET CarCompara	:=	SUBSTRING(Var_RazonSoc,ContadorY,Entero_Uno);

									IF(CarOriginal = CarCompara) THEN
										SET Coincidencia6 := Coincidencia6 + Entero_Uno;
										SET NuvaCadena	:= CONCAT(NuvaCadena,SUBSTRING(Var_RazonSoc,(ContadorY+Entero_Uno),LongRazSocAux));
										SET ContadorY	:=	LongRazSocAux;
									ELSE
										SET NuvaCadena := CONCAT(NuvaCadena,CarCompara);
									END IF;

									 IF(ContadorY = LongRazSocAux)THEN
											SET Var_RazonSoc := NuvaCadena;
											SET LongRazSocAux := LENGTH(Var_RazonSoc);
									END IF;

									SET ContadorY	:=	ContadorY + Entero_Uno;
									SET LongRazSocAux := LENGTH(Var_RazonSoc);

								END WHILE;

								SET ContadorX	:=	ContadorX + Entero_Uno;
							END WHILE;

							IF (LongRazSoc = Coincidencia6) THEN

								SET Auxiliar6 :=	(Coincidencia6 * Entero_Cien) / TmpLogitud;
							ELSE
								SET Auxiliar6 :=	(Coincidencia6 * Entero_Cien) / LongRazSoc;
							END IF;


							IF (Porcentaje6 < Auxiliar6)THEN
								SET Porcentaje6 := Auxiliar6;
							END IF;
							-- Fin seccion para personas Morales
						END IF;
						-- Fin de la concicion para comparar los nombres
						IF(IFNULL(Par_PrimerNombre,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_SegundoNombre,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_TercerNombre,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_ApePaterno,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_ApeMaterno,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;
						IF(IFNULL(Par_RazonSocial,Cadena_Vacia)!=Cadena_Vacia) THEN
							SET TotalNombres := TotalNombres + Entero_Uno;
						END IF;

						SET PorcentajeTotal :=	(Porcentaje1 + Porcentaje2 + Porcentaje3 + Porcentaje4 + Porcentaje5 + Porcentaje6)/TotalNombres;


					IF(PorcentajeTotal >= Par_Porcentaje)THEN
						SELECT IFNULL(MAX(CoincidenciaID),Entero_Cero)+ Entero_Uno
						INTO Indice FROM `TMPCOINCIDENCIASPLD`;

						INSERT INTO `TMPCOINCIDENCIASPLD`(
							`CoincidenciaID`,		`ClavePersonaID`,		PersonaBloqID,			`TipoPersSAFI`,		`Coincidencia`, 	`NumTransaccion`)
						  VALUES(
							Indice,					Par_ClavePersonaID,		Var_PersonaBloqID,		Par_TipoPersSAFI,	PorcentajeTotal,	Aud_NumTransaccion);
					END IF;
				END LOOP;
			END;
		CLOSE CursorLisNegras;
	END IF;


SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := 'Proceso Terminado Exitosamente';
SET Var_Control := 'Control';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT Par_NumErr AS NumErr,
		   Par_ErrMen AS ErrMen,
		   Var_Control AS Control;
END IF;



END TerminaStored$$