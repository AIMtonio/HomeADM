-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPUESTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `IMPUESTOSCON`;DELIMITER $$

CREATE PROCEDURE `IMPUESTOSCON`(

    Par_ImpuestoID      INT(11),
    Par_NumCon          TINYINT UNSIGNED,

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(20),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
        )
TerminaStore: BEGIN

DECLARE     Con_Principal   INT;
DECLARE     Con_Foranea     INT;
DECLARE     Con_Impuestos   INT;
DECLARE 	Con_NumImpues	INT;


SET Con_Principal   := 1;
SET Con_Foranea     := 2;
SET Con_Impuestos   := 3;
SET Con_NumImpues	:= 4;


IF(Par_NumCon = Con_Principal) THEN
    SELECT  Tasa,   DescripCorta
    FROM    IMPUESTOS
    WHERE   ImpuestoID  = Par_ImpuestoID;
END IF;


IF(Par_NumCon = Con_Impuestos) THEN
    SELECT  ImpuestoID, Descripcion,        DescripCorta,   Tasa,       GravaRetiene,
            BaseCalculo,ImpuestoCalculo,    CtaEnTransito,  CtaRealizado
    FROM    IMPUESTOS
    WHERE   ImpuestoID  = Par_ImpuestoID;
END IF;

IF(Par_NumCon = Con_NumImpues) THEN
	SELECT COUNT(DISTINCT (I.DescripCorta))  AS  NumImpuestos
	FROM PROVEEDORES P
	INNER JOIN TIPOPROVEEDORES T ON P.TipoProveedor = T.TipoProveedorID
	INNER JOIN TIPOPROVEIMPUES TI ON T.TipoProveedorID = TI.TipoProveedorID
	INNER JOIN IMPUESTOS I ON TI.ImpuestoID = I.ImpuestoID;
END IF;


END TerminaStore$$