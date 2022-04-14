-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VERIFICADOMICILIOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `VERIFICADOMICILIOREP`;DELIMITER $$

CREATE PROCEDURE `VERIFICADOMICILIOREP`(

	Par_ClienteID			INT(11),

	Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP			VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_ClienteID 		INT(11);
DECLARE Var_NombreCli 		VARCHAR(200);
DECLARE Var_OcupacionID		INT(5);
DECLARE Var_TipoIdentiID	INT(11);
DECLARE Var_Identificacion	VARCHAR(80);
DECLARE	Var_Ocupacion		TEXT;
DECLARE	Var_Calle			VARCHAR(50);
DECLARE Var_NumCasa			CHAR(10);
DECLARE Var_NumInt			CHAR(10);
DECLARE Var_ColoniaID		INT(11);
DECLARE Var_CP				CHAR(5);
DECLARE Var_Referencia		VARCHAR(200);
DECLARE Var_MunicipioID		INT(11);
DECLARE Var_LocalidadID		INT(11);
DECLARE Var_EstadoID		INT(11);
DECLARE Var_Piso			CHAR(50);
DECLARE	Var_Estado			VARCHAR(100);
DECLARE Var_Asentamiento	VARCHAR(200);
DEClARE	Var_Municipio		VARCHAR(150);
DECLARE	Var_NombreLocal 	VARCHAR(200);


DECLARE Oficial_SI			CHAR(1);
DECLARE	Cadena_Vacia			char(1);


SET Oficial_SI			:= 'S';
Set	Cadena_Vacia		:= '';


SELECT ClienteID, 	NombreCompleto,		OcupacionID
	INTO Var_ClienteID,	Var_NombreCli,	Var_OcupacionID
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID;


SELECT TipoIdentiID, 	CONCAT(Descripcion,' ',NumIdentific)
	INTO Var_TipoIdentiID,	Var_Identificacion
		FROM IDENTIFICLIENTE
		WHERE ClienteID = Var_ClienteID	AND	Oficial = Oficial_SI
		LIMIT 1;


SELECT Descripcion
	INTO Var_Ocupacion
		FROM OCUPACIONES
		WHERE OcupacionID = Var_OcupacionID;


SELECT  Dir.Calle,			Dir.NumeroCasa,		Dir.NumInterior,	Dir.ColoniaID,	Dir.CP,
		Dir.Descripcion,	Dir.MunicipioID,	Dir.LocalidadID,	Dir.EstadoID,	Dir.Piso
	INTO 	Var_Calle,		Var_NumCasa,		Var_NumInt,			Var_ColoniaID,	Var_CP,
			Var_Referencia,	Var_MunicipioID,	Var_LocalidadID,	Var_EstadoID,	Var_Piso
		FROM DIRECCLIENTE Dir
		WHERE Dir.ClienteID = Var_ClienteID	AND Dir.Oficial = Oficial_SI
		LIMIT 1;

IF(IFNULL(Var_EstadoID,Cadena_Vacia)= Cadena_Vacia)THEN
	SELECT  Dir.Calle,			Dir.NumeroCasa,		Dir.NumInterior,	Dir.ColoniaID,	Dir.CP,
		Dir.Descripcion,	Dir.MunicipioID,	Dir.LocalidadID,	Dir.EstadoID,	Dir.Piso
	INTO 	Var_Calle,		Var_NumCasa,		Var_NumInt,			Var_ColoniaID,	Var_CP,
			Var_Referencia,	Var_MunicipioID,	Var_LocalidadID,	Var_EstadoID,	Var_Piso
		FROM DIRECCLIENTE Dir
		WHERE Dir.ClienteID = Var_ClienteID
		LIMIT 1;
END IF;




SELECT Est.Nombre,	Col.Asentamiento,	Mun.Nombre,		Loc.NombreLocalidad
	INTO Var_Estado,	Var_Asentamiento,	Var_Municipio,	Var_NombreLocal
	FROM ESTADOSREPUB Est
		INNER JOIN MUNICIPIOSREPUB Mun ON Est.EstadoID = Mun.EstadoID
		INNER JOIN LOCALIDADREPUB Loc ON  Mun.MunicipioID = Loc.MunicipioID AND Est.EstadoID = Loc.EstadoID
		LEFT JOIN COLONIASREPUB Col ON Mun.MunicipioID = Col.MunicipioID AND Est.EstadoID = Col.EstadoID
	WHERE	Est.EstadoID = Var_EstadoID	AND Mun.MunicipioID = Var_MunicipioID
			AND Loc.LocalidadID = Var_LocalidadID AND Col.ColoniaID	= Var_ColoniaID;



SELECT  Var_ClienteID	AS  ClienteID,			Var_NombreCli AS NombreCompleto,
		Var_TipoIdentiID AS TipoIdentiID,		Var_Identificacion AS Identificacion,
		Var_Calle	AS Calle,					Var_NumCasa AS NumeroCasa,
		Var_NumInt AS NumInterior,				Var_ColoniaID AS ColoniaID,
		Var_Asentamiento AS Asentamiento,		Var_CP AS CP,
		Var_Referencia AS Referencia,			Var_MunicipioID AS MunicipioID,
		Var_Municipio AS Municipio,				Var_LocalidadID	AS LocalidadID,
		Var_NombreLocal AS NombreLocalidad,		Var_EstadoID AS EstadoID,
		Var_Estado AS Estado,					Var_OcupacionID	AS	OcupacionID,
		Var_Ocupacion AS Ocupacion,				Var_Piso AS Piso;

END TerminaStore$$