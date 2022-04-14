-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFERECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFERECON`;DELIMITER $$

CREATE PROCEDURE `DEPOSITOREFERECON`(
	/* CONSULTA DE DEPÓSITOS REFERENCIADOS. */
	Par_InstitucionID		INT(11),
	Par_CuentaAhoID			VARCHAR(20),
	Par_NumIdenArchivo		VARCHAR(20),
	Par_NumConsulta			INT(11),
	/* Parámetros de Auditoría */
	Aud_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- declaracion de constantes
DECLARE Con_Principal	INT;
DECLARE Con_NumIdArch	INT;

-- asignacion de constantes
SET Con_Principal := 1; -- Consulta principal.
SET	Con_NumIdArch := 2; -- Consulta el numero de transaccion del archivo.

IF(Par_NumConsulta  = Con_Principal) THEN

	SELECT  D.FolioCargaID,   D.NumeroMov,  D.FechaAplica,    D.ReferenciaMov,  D.DescripcionMov,
			D.TipoCanal,      D.MontoMov,   D.MontoPendApli,  D.TipoDeposito,   D.Status,
			D.NatMovimiento,  D.Monedaid,   M.Descripcion

	FROM DEPOSITOREFERE D INNER JOIN MONEDAS M
	 ON  D.CuentaAhoID =Par_CuentaAhoID AND D.InstitucionID =Par_InstitucionID AND D.Status='NI'
	 AND M.Monedaid= D.Monedaid;

END IF;

IF(Par_NumConsulta = Con_NumIdArch) THEN
	SELECT COUNT(FolioCargaID) AS NumReg
		FROM DEPOSITOREFERE
			WHERE NumIdenArchivo = Par_NumIdenArchivo;
END IF;

END TerminaStore$$