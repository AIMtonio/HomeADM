-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOEVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOEVAL`;DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOEVAL`(

	Par_LinNegID     	INT,
	Par_ClienteID       INT(11),
    Par_ProspectoID	    INT(11),
	Par_FechaReg		DATE,
	Par_TipoVal         INT,

    Par_Salida          CHAR(1),
    inout Par_NumErr    INT,
    inout Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN



DECLARE VarNumSocioID   	INT;
DECLARE Var_Pivote			VARCHAR(15);
DECLARE Var_Cte				INT;
DECLARE Var_LinNegID		INT;
DECLARE Var_MenorEdad		CHAR(1);
DECLARE Var_Estatus        	CHAR(1);


DECLARE Tipo_valIndividual		INT;
DECLARE Tipo_valGrupal			INT;
DECLARE Entero_Cero				INT;
DECLARE Con_Str_SI				CHAR;
DECLARE Con_Str_NO				CHAR;
DECLARE	Cadena_Vacia			CHAR;
DECLARE Val_Ratios				INT;
DECLARE Val_DatSoc              INT;
DECLARE MenorEdad				CHAR(1);
DECLARE EstInactivo        		CHAR(1);


SET Cadena_Vacia	:=	'';
SET	Con_Str_SI		:=	'S';
SET Con_Str_NO		:=	'N';
SET MenorEdad		:=	'S';
SET EstInactivo     :=	'I';
SET Entero_Cero		:=	0;
SET Par_NumErr  	:=	1;
SET Val_Ratios      :=	1;
SET Val_DatSoc      :=	2;




SET Aud_FechaActual := CURRENT_TIMESTAMP();


SET     Par_NumErr  := 1;
SET 	Par_ErrMen  	:= Cadena_Vacia;
SET		Par_FechaReg:=	(SELECT FechaSistema FROM PARAMETROSSIS);

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := '999';
					SET Par_ErrMen := concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
											 'estamos trabajando para resolverla. Disculpe las molestias que ',
											 'esto le ocasiona. Ref: SP-CLIDATSOCIOEVAL');
					SET Var_Pivote := 'sqlException' ;
				END;




IF (Par_TipoVal = Val_Ratios) THEN
	IF(Par_ClienteID > Entero_Cero)THEN
		IF NOT EXISTS(	SELECT  SocioEID
						FROM CLIDATSOCIOE
						WHERE ClienteID = Par_ClienteID ) THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= concat("El cliente ", cast(Par_ClienteID AS CHAR) ," no tiene los datos socioeconomicos capturados.");
			IF Par_Salida = Con_Str_SI THEN
				SELECT  '001' AS NumErr,
						Par_ErrMen AS ErrMen,
						'clienteID' AS control,
						Entero_Cero AS consecutivo;
			END IF;
			LEAVE TerminaStore;
		END IF;

	ELSE
		IF NOT EXISTS(	SELECT  SocioEID
						FROM CLIDATSOCIOE
						WHERE ProspectoID = Par_ProspectoID ) THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= concat("El prospecto ", cast(Par_ProspectoID AS CHAR) ," no tiene los datos socioeconomicos capturados.");
			IF Par_Salida = Con_Str_SI THEN
				SELECT  '002' AS NumErr,
						Par_ErrMen AS ErrMen,
						'prospectoID' AS control,
						Entero_Cero AS consecutivo;
			END IF;
			LEAVE TerminaStore;
		END IF;

	END IF;

	SET     Par_NumErr  := 0;
	SET     Par_ErrMen  := concat("El Cliente ya tiene sus datos Socioeconomicos Completos.");

		IF Par_Salida = Con_Str_SI THEN
			SELECT  '000' AS NumErr,
					Par_ErrMen AS ErrMen,
					'clienteID' AS control,
					Entero_Cero AS consecutivo;
		END IF;
END IF;





IF (Par_TipoVal = Val_DatSoc) THEN

SELECT ClienteID, EsMenorEdad, Estatus
		INTO Var_Cte, Var_MenorEdad, Var_Estatus
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;


	SET Var_Cte 		:= IFNULL(Var_Cte, Entero_Cero);
	SET Var_MenorEdad 	:= IFNULL(Var_MenorEdad, Cadena_Vacia);


	SELECT ProspectoID, ClienteID
		INTO	Par_ProspectoID, Par_ClienteID
		FROM	PROSPECTOS
		WHERE	ProspectoID = Par_ProspectoID;

	SET Var_LinNegID   := (SELECT LinNegID
							FROM CATLINEANEGOCIO
							WHERE LinNegID = Par_LinNegID);

	SET Var_LinNegID   := IFNULL(Var_LinNegID, Entero_Cero);

	IF(ifnull(Par_ClienteID, Entero_Cero) = Entero_Cero and ifnull(Par_ProspectoID, Entero_Cero) = Entero_Cero) THEN
			SET	Par_ErrMen := 'El Prospecto y Cliente están vacios.' ;
			IF(Par_Salida = Con_Str_SI) THEN
				SELECT '001' AS NumErr,
					Par_ErrMen AS ErrMen,
					'clienteID' AS control,
					Entero_Cero AS consecutivo;
				LEAVE TerminaStore;
			END IF;
	END IF;

	IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero) THEN
		IF(IFNULL(Var_Cte, Entero_Cero) = Entero_Cero) THEN
				SET	Par_ErrMen := 'El Cliente no existe.' ;
				IF(Par_Salida = Con_Str_SI) THEN
					SELECT '002' AS NumErr,
						Par_ErrMen AS ErrMen,
						Var_Pivote AS control,
						Entero_Cero AS consecutivo;
					LEAVE TerminaStore;
				END IF;
			END IF;
		ELSE

			IF (ifnull(Par_ProspectoID, Entero_Cero) = Entero_Cero) THEN
					SET	Par_ErrMen := 'El Prospecto no existe.' ;
					IF(Par_Salida = Con_Str_SI) THEN
						SELECT '003' AS NumErr,
							Par_ErrMen AS ErrMen,
							Var_Pivote AS control,
							Entero_Cero AS consecutivo;
						LEAVE TerminaStore;
					END IF;
			END IF;
		END IF;


	IF (Var_LinNegID = Entero_Cero) THEN
		SET	Par_ErrMen := 'La Linea de Negocio no Existe' ;
		IF(Par_Salida = Con_Str_SI) THEN
			SELECT '004' AS NumErr,
				Par_ErrMen AS ErrMen,
				'LinNegID' AS control,
				Entero_Cero AS consecutivo;
			LEAVE TerminaStore;
		END IF;
	END IF;

	IF(Var_MenorEdad = MenorEdad)THEN
		SET	Par_ErrMen := 'El Cliente es Menor de Edad.' ;
		IF(Par_Salida = Con_Str_SI) THEN
			SELECT '005' AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Pivote AS control,
				Entero_Cero AS consecutivo;
			LEAVE TerminaStore;
		END IF;
	END IF;


	IF(IFNULL(Par_ClienteID, Entero_Cero) > Entero_Cero) THEN
		IF(IFNULL(Var_Estatus, Cadena_Vacia) = EstInactivo) THEN
				SET	Par_ErrMen := 'El Cliente se encuentra Inactivo.' ;
				IF(Par_Salida = Con_Str_SI) THEN
					SELECT '006' AS NumErr,
						Par_ErrMen AS ErrMen,
						Var_Pivote AS control,
						Entero_Cero AS consecutivo;
					LEAVE TerminaStore;
				END IF;
			END IF;
	END IF;

	IF(Par_Salida = Con_Str_SI) THEN
		SELECT '000' AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Pivote AS control,
				VarNumSocioID AS consecutivo;
	END IF;

END IF;

END ManejoErrores;


END TerminaStore$$