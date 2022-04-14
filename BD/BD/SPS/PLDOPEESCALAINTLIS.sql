-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEESCALAINTLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEESCALAINTLIS`;DELIMITER $$

CREATE PROCEDURE `PLDOPEESCALAINTLIS`(

    Par_ProcesoEscID    VARCHAR(16),
    Par_NombreComp      VARCHAR(100),
    Par_NumLis          TINYINT UNSIGNED,
    Par_EmpresaID       INT,

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
			)
TerminaStore: BEGIN


DECLARE Cadena_Vacia	CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Entero_Cero		INT;
DECLARE Lis_Principal	INT;
DECLARE Lis_OpVentani	INT;


SET Cadena_Vacia	:= '';
SET Fecha_Vacia		:= '1900-01-01';
SET Entero_Cero		:= 0;
SET Lis_Principal	:= 1;
SET Lis_OpVentani	:= 2;

IF(Par_NumLis = Lis_Principal) THEN
	SELECT OperProcesoID, NombreCompleto
        FROM PLDOPEESCALAINT Ope,
             CLIENTES Cli
        WHERE ProcesoEscID      = Par_ProcesoEscID
          AND Cli.ClienteID     = Ope.ClienteID
          AND Cli.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
	LIMIT 0, 15;
END IF;

IF(Par_NumLis = Lis_OpVentani) THEN
	SELECT
	FolioEscala,
	CASE WHEN Tmp.ClienteID IS NOT NULL THEN Cl.NombreCompleto ELSE
							Us.NombreCompleto END AS NombreCompleto,
	format(Monto,2) as Monto,
	DATE(FechaOperacion) as Fecha,
	Tpl.Descripcion as Estatus, Opc.Descripcion as Operacion
			FROM TMPPLDVENESCALA AS Tmp
				INNER JOIN OPCIONESCAJA as Opc	ON Tmp.OpcionCajaID=Opc.OpcionCajaID
                INNER JOIN TIPORESULESCPLD as Tpl On Tmp.TipoResultEscID=Tpl.TipoResultEscID
				LEFT JOIN CLIENTES AS Cl ON Tmp.ClienteID=Cl.ClienteID
                LEFT JOIN USUARIOSERVICIO AS Us on Tmp.UsuarioServicioID=Us.UsuarioServicioID
				 WHERE UPPER(Cl.NombreCompleto) LIKE CONCAT("%", UPPER(Par_NombreComp), "%")
				OR UPPER(Us.NombreCompleto) LIKE CONCAT("%", UPPER(Par_NombreComp), "%")
					LIMIT 0, 15;
END IF;

END TerminaStore$$