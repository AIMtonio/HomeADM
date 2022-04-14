-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LOTETARJETACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LOTETARJETACON`;
DELIMITER $$

CREATE PROCEDURE `LOTETARJETACON`(
    Par_LoteDebitoID        INT(11),
    Par_NumCon              INT(11),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN

DECLARE Var_Estatus				INT;
DECLARE	Var_TipoTarjetaDebID	INT(11);
DECLARE	Var_ClienteID			INT(11);
DECLARE	Var_CuentaAhoID			BIGINT(12);
DECLARE Var_TipoCuentaID		INT(11);
DECLARE Var_ComisionAnual		DECIMAL(14,2);
DECLARE Var_PagoComAnual		CHAR(1);
DECLARE Var_FPagoComAnual		DATE;
DECLARE Var_FechaProximoPag		DATE;
DECLARE Var_FechaActivacion		DATE;


DECLARE Con_Principal  		INT;
DECLARE Con_TarjetaSAFI     INT(11);
DECLARE Var_LoteDebitoID    INT;
DECLARE Var_FolFinal 		INT;
DECLARE Entero_Cero		 	INT;
DECLARE Cadena_Vacia		CHAR(1);


SET Con_Principal   :=22;
SET Con_TarjetaSAFI :=23;
SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;


    IF(Par_NumCon = Con_Principal) THEN
        SELECT (MAX(LoteDebitoID)) INTO Var_LoteDebitoID
                    FROM LOTETARJETADEB;

        SELECT (MAX(FolioFinal)) INTO Var_FolFinal
                            FROM LOTETARJETADEB;

        SET Var_LoteDebitoID:= IFNULL( Var_LoteDebitoID, Entero_Cero);
        SET Var_FolFinal    := IFNULL( Var_FolFinal, Entero_Cero);

        SELECT
             Var_LoteDebitoID AS LoteDebitoID,     `TipoTarjetaDebID`,         `FechaRegistro`,    `SucursalSolicita`, `Estatus`,
			 `EsAdicional`,          Var_FolFinal AS FolioFinal
        FROM LOTETARJETADEB;
    END IF;

    -- CONSULTA EN TABLE LOTETARJETADEBSAFI PARA TARJETAS GENERADAS EN SAFI
    IF(Par_NumCon = Con_TarjetaSAFI) THEN
        SELECT (MAX(LoteDebSAFIID)) INTO Var_LoteDebitoID
                    FROM LOTETARJETADEBSAFI;

        SELECT (MAX(FolioFinal)) INTO Var_FolFinal
                            FROM LOTETARJETADEBSAFI;

        SET Var_LoteDebitoID:= IFNULL( Var_LoteDebitoID, Entero_Cero);
        SET Var_FolFinal    := IFNULL( Var_FolFinal, Entero_Cero);

        SELECT
             Var_LoteDebitoID AS LoteDebitoID,     `TipoTarjetaDebID`,         `FechaRegistro`,    `SucursalSolicita`, `Estatus`,
             `EsAdicional`,          Var_FolFinal AS FolioFinal
        FROM LOTETARJETADEBSAFI LIMIT 1;
    END IF;

END TerminaStore$$