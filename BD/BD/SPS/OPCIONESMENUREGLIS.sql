-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESMENUREGLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESMENUREGLIS`;
DELIMITER $$

CREATE PROCEDURE `OPCIONESMENUREGLIS`(
/* *******************************************************************
    SP QUE LISTA LAS OPCIONES PARA LOS MENUS DE LOS REGULATORIOS
********************************************************************* */
    Par_MenuID			INT,				# Id del Menu a consultar
    Par_Compara		    VARCHAR(50),		# Parametro a comparar
	Par_NumCon		    TINYINT UNSIGNED,	# Numero de consulta

	Aud_Empresa		    INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Principal 	  	INT;
DECLARE Combo     	  	INT;
DECLARE EntidadFinan  	INT;
DECLARE	Con_TipoValor 	INT;
DECLARE Con_DesTipValor INT;

SET Principal     	:= 1;
SET Combo         	:= 2;
SET EntidadFinan  	:= 3;
SET Con_TipoValor 	:= 4;
SET Con_DesTipValor := 5;

/* ---------------------------------------------------
Consulta principal para obtener la Entidad Financiera
----------------------------------------------------- */
IF(Par_NumCon = Principal) THEN
	SELECT OpcionMenuID, CodigoOpcion, Descripcion FROM
    OPCIONESMENUREG WHERE MenuID = Par_MenuID AND Descripcion LIKE CONCAT('%',Par_Compara,'%') LIMIT 15;
END IF;

/* ---------------------------------------------------
Consulta que devuelve las opciones para un combo
----------------------------------------------------- */
IF(Par_NumCon = Combo) THEN
	SELECT OpcionMenuID, CodigoOpcion, Descripcion FROM
    OPCIONESMENUREG WHERE MenuID = Par_MenuID;
END IF;

/* ------------------------------------------------------------
Consulta que devuelve la descripcion de una entidad financiera
-------------------------------------------------------------- */
IF(Par_NumCon = EntidadFinan) THEN
	SELECT OpcionMenuID, CodigoOpcion, Descripcion FROM
    OPCIONESMENUREG WHERE MenuID = Par_MenuID AND TRIM(LEADING '0' FROM CodigoOpcion) = TRIM(LEADING '0' FROM Par_Compara);
END IF;


/* -------------------------------------------------------------
Consulta que devuelve la lista de opciones para el tipo de valor
----------------------------------------------------------------*/
IF(Par_NumCon = Con_TipoValor) THEN
	select ClaveValor as CodigoOpcion, TipoValorID as OpcionMenuID,Descripcion from CATTIPOVALOR
    WHERE Descripcion LIKE CONCAT('%',Par_Compara,'%') LIMIT 15;
END IF;

/* ------------------------------------------------------------
Consulta que devuelve la descripcion de un Tipo de Valor
-------------------------------------------------------------- */
IF(Par_NumCon = Con_DesTipValor) THEN
	SELECT ClaveValor as CodigoOpcion ,TipoValorID as OpcionMenuID, Descripcion FROM
    CATTIPOVALOR WHERE ClaveValor = Par_Compara;
END IF;


END TerminaStore$$