-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMUACIRIESGOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMUACIRIESGOSLIS`;DELIMITER $$

CREATE PROCEDURE `PARAMUACIRIESGOSLIS`(

	Par_ParamRiesgosID  INT(11),
	Par_Descripcion		VARCHAR(100),
	Par_NumLis			TINYINT UNSIGNED,
	Par_EmpresaID		INT(11),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


DECLARE Var_Dinamico 	CHAR(1);
DECLARE Var_Porcentaje  DECIMAL(10,2);


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	Decimal_Cero	DECIMAL(12,2);
DECLARE Lis_Combo 		INT(11);
DECLARE Lis_Porcentaje 	INT(11);
DECLARE Lis_ClasCred	INT(11);
DECLARE Lis_TipoAhorro	INT(11);
DECLARE Lis_SectorEcon  INT(11);
DECLARE DinamicoNO 		CHAR(1);
DECLARE ParamCredConsum INT(11);
DECLARE ParamTipoAhorro INT(11);
DECLARE ParamSectorEco  INT(11);


SET Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Decimal_Cero		:= 0.0;
SET Lis_Combo 			:= 1;
SET Lis_Porcentaje      := 2;
SET Lis_ClasCred      	:= 3;
SET Lis_TipoAhorro      := 4;
SET Lis_SectorEcon		:= 5;
SET DinamicoNO 		    := 'N';
SET ParamCredConsum     := 7;
SET ParamTipoAhorro     := 18;
SET ParamSectorEco      := 16;


SELECT Dinamico INTO Var_Dinamico FROM CATPARAMRIESGOS WHERE CatParamRiesgosID = Par_ParamRiesgosID;


SELECT Porcentaje INTO Var_Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = Par_ParamRiesgosID LIMIT 1;

SET Var_Porcentaje := IFNULL(Var_Porcentaje, Decimal_Cero);


IF(Par_NumLis = Lis_Combo) then
		SELECT CatParamRiesgosID,Descripcion
			FROM CATPARAMRIESGOS;
END IF;


IF(Par_NumLis = Lis_Porcentaje) then
		IF(Var_Dinamico = DinamicoNO) then
			SELECT	Cat.CatParamRiesgosID,Cat.Descripcion, Cat.Dinamico,IFNULL(Par.Porcentaje,Cadena_Vacia) AS Porcentaje,
				IFNULL(Par.ReferenciaID,Cadena_Vacia) AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			LEFT JOIN PARAMUACIRIESGOS Par
				ON Cat.CatParamRiesgosID = Par.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	ELSE
	SELECT	Cat.CatParamRiesgosID,IFNULL(Par.Descripcion,Cadena_Vacia) AS Descripcion, Cat.Dinamico, IFNULL(Par.Porcentaje,Cadena_Vacia) AS Porcentaje,
				IFNULL(Par.ReferenciaID,Cadena_Vacia) AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			LEFT JOIN PARAMUACIRIESGOS Par
				ON Cat.CatParamRiesgosID = Par.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	END IF;
END IF;


IF(Par_NumLis = Lis_ClasCred) THEN
	IF(Par_ParamRiesgosID = ParamCredConsum AND Var_Porcentaje = Decimal_Cero) THEN
		SELECT Cat.CatParamRiesgosID,	Cla.Descripcion, 	Cat.Dinamico,	Cadena_Vacia AS Porcentaje,
				Cadena_Vacia AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			INNER JOIN CATCLASIFICACRED Cla
					ON Cat.CatParamRiesgosID = Cla.CatParamRiesgosID
				WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	ELSE
	SELECT Cat.CatParamRiesgosID,	IFNULL(Par.Descripcion,Cadena_Vacia) AS Descripcion, 	Cat.Dinamico,
			IFNULL(Par.Porcentaje,Cadena_Vacia) AS Porcentaje,
				IFNULL(Par.ReferenciaID,Cadena_Vacia) AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			LEFT JOIN PARAMUACIRIESGOS Par
				ON Cat.CatParamRiesgosID = Par.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	END IF;
END IF;


IF(Par_NumLis = Lis_TipoAhorro) THEN
	IF(Par_ParamRiesgosID = ParamTipoAhorro AND Var_Porcentaje = Decimal_Cero) THEN
		SELECT Cat.CatParamRiesgosID,	Cla.Descripcion, 	Cat.Dinamico,Cadena_Vacia AS Porcentaje,
				Cadena_Vacia AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			INNER JOIN CATTIPOSAHORRO Cla
				ON Cat.CatParamRiesgosID = Cla.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	ELSE
	SELECT	Cat.CatParamRiesgosID,IFNULL(Par.Descripcion,Cadena_Vacia) AS Descripcion, 	Cat.Dinamico,
			IFNULL(Par.Porcentaje,Cadena_Vacia) AS Porcentaje,	IFNULL(Par.ReferenciaID,Cadena_Vacia) AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			LEFT JOIN PARAMUACIRIESGOS Par
				ON Cat.CatParamRiesgosID = Par.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	END IF;
END IF;


IF(Par_NumLis = Lis_SectorEcon) THEN
	IF(Par_ParamRiesgosID = ParamSectorEco AND Var_Porcentaje = Decimal_Cero) THEN
		SELECT Cat.CatParamRiesgosID,	Cla.Descripcion, 	Cat.Dinamico,Cadena_Vacia AS Porcentaje,
				Cadena_Vacia AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			INNER JOIN CATSECTORECONOMICO Cla
				ON Cat.CatParamRiesgosID = Cla.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	ELSE
	SELECT	Cat.CatParamRiesgosID,IFNULL(Par.Descripcion,Cadena_Vacia) AS Descripcion, 	Cat.Dinamico,
			IFNULL(Par.Porcentaje,Cadena_Vacia) AS Porcentaje,	IFNULL(Par.ReferenciaID,Cadena_Vacia) AS ReferenciaID
		FROM CATPARAMRIESGOS Cat
			LEFT JOIN PARAMUACIRIESGOS Par
				ON Cat.CatParamRiesgosID = Par.CatParamRiesgosID
			WHERE Cat.CatParamRiesgosID = Par_ParamRiesgosID;
	END IF;
END IF;

END TerminaStore$$