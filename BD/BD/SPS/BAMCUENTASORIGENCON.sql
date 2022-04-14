-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BAMCUENTASORIGENCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BAMCUENTASORIGENCON`;DELIMITER $$

CREATE PROCEDURE `BAMCUENTASORIGENCON`(

-- Store para consultar las cuentas origen del usuario
	Par_CuentaAhoID			BIGINT(12),			-- ID de la cuenta cargo que queremos consultar
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
    Par_ClienteID			INT(11), 			-- Cliente ID

	Par_EmpresaID       	INT(11),			-- Auditoria
    Aud_Usuario         	INT(11),			-- Auditoria
    Aud_FechaActual     	DATETIME,			-- Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Auditoria
    Aud_Sucursal        	INT(11),			-- Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Auditoria
	)
TerminaStore: BEGIN

-- Declaracion de Constantes
	DECLARE Con_Principal	 INT;
    DECLARE Con_Verificacion INT;

-- Asignacion de Constantes
	SET	Con_Principal		:= 1;				-- Consulta principal
    SET Con_Verificacion    := 2;				-- Verfica cuando se abrio la cuenta y en que sucursal

	IF (Par_NumCon=Con_Principal) THEN
		SELECT  	bu.ClienteID, 	ca.TipoCuentaID, 	ca.FechaApertura, 	ca.SucursalID, 	tc.Descripcion,
					s.NombreSucurs

			FROM BAMUSUARIOS bu  INNER JOIN CUENTASAHO   ca ON bu.ClienteID    = ca.ClienteID
								 INNER JOIN TIPOSCUENTAS tc ON ca.TipoCuentaID = tc.TipoCuentaID
								 INNER JOIN SUCURSALES   s  ON ca.SucursalID   = s.SucursalID
								 WHERE ca.CuentaAhoID=Par_CuentaAhoID
								 GROUP BY ca.CuentaAhoID;
	ELSEIF (Par_NumCon=Con_Verificacion) THEN
		SELECT 		ca.ClienteID, 	ca.TipoCuentaID, 	ca.FechaApertura, 	ca.SucursalID
			FROM CUENTASAHO ca
			WHERE ca.CuentaAhoID=Par_CuentaAhoID AND ca.ClienteID=Par_ClienteID;
	END IF;
END TerminaStore$$