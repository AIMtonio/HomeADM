-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCRENOMBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCRENOMBALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCRENOMBALT`(
    Par_SolicitudID     VARCHAR(10),
	Par_ApePaterno		VARCHAR(45),
	Par_ApeMaterno		VARCHAR(45),
	Par_ApeAdicional	VARCHAR(45),
	Par_Nombres			VARCHAR(45),

	Par_FechaNacimiento	DATETIME,
	Par_RFC				VARCHAR(45),
	Par_CURP 			VARCHAR(45),
	Par_Nacionalidad	VARCHAR(45),
	Par_Residencia		VARCHAR(45),

	Par_EstadoCivil		VARCHAR(45),
	Par_Sexo			VARCHAR(45),
	Par_ClaveIFE		VARCHAR(45),
	Par_NumDependiente	INT(11),
	Par_FechaDefuncion	DATETIME,

	Par_Salida			CHAR(1),
    INOUT	Par_NumErr	INT,
    INOUT	Par_ErrMen	VARCHAR(350)
)
TerminaStore: BEGIN


DECLARE varControl		VARCHAR(50);


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Fecha_Alta		DATE;
DECLARE	Salida_SI       CHAR(1);
DECLARE	Var_NO			CHAR(1);


SET Cadena_Vacia		:= '';
SET Fecha_Vacia			:= '1900-01-01';
SET Entero_Cero			:= 0;
SET Salida_SI			:='S';
SET Var_NO				:='N';

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CIRCULOCRENOMBALT');
		SET varControl := 'sqlException';
    END;

	INSERT INTO CIRCULOCRENOMB(
		fk_SolicitudID,			ApePaterno,			ApeMaterno,			ApeAdicional,		Nombres,
		FechaNacimiento,		RFC,				Nacionalidad, 		Residencia,			EstadoCivil,
		Sexo,					ClaveIFE,			NumDependiente,		FechaDefuncion,		CURP
	) VALUES (
		Par_SolicitudID,    	Par_ApePaterno,		Par_ApeMaterno,		Par_ApeAdicional,	Par_Nombres,
		Par_FechaNacimiento,	Par_RFC,			Par_Nacionalidad, 	Par_Residencia,		Par_EstadoCivil,
		Par_Sexo,				Par_ClaveIFE,		Par_NumDependiente,	Par_FechaDefuncion,	Par_CURP
	);

	SET Par_NumErr  := 000;
	SET Par_ErrMen  := CONCAT('La Cadena de envÃ­o se ha insertado correctamente: ',Par_SolicitudID);
	SET varControl	:= 'fk_SolicitudID';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
END IF;

END TerminaStore$$