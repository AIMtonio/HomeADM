-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBPAGOCOMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBPAGOCOMREP`;DELIMITER $$

CREATE PROCEDURE `TARDEBPAGOCOMREP`(




	Par_TipoTarjetaDebID	INT(11),
	Par_FechaSistema		DATE,

	Par_NumRep			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
	)
TerminaStore: BEGIN


DECLARE	Rep_Principal		INT;





SET	Rep_Principal		:= 1;

IF(Par_NumRep = Rep_Principal) THEN

	SELECT  LPAD(CONVERT(Cli.ClienteID, CHAR), 11, 0) AS ClienteID, Cli.Nombrecompleto AS NombreCliente, Tar.FPagoComAnual,
			Tip.Descripcion AS TipoTarjeta, Tar.TarjetaDebID,  Pag.MontoComision, Pag.MontoIVA,	Pag.MontoTotal
		FROM TARDEBPAGOCOM Pag,
			 CLIENTES Cli,
			 TIPOTARJETADEB Tip,
			 TARJETADEBITO Tar
		WHERE	Tar.TipoTarjetaDebID = Par_TipoTarjetaDebID
			AND Pag.Fecha =	Par_FechaSistema
			AND Pag.ClienteID = Cli.ClienteID
			AND Tar.TipoTarjetaDebID = Tip.TipoTarjetaDebID
			AND Pag.TarjetaDebID = Tar.TarjetaDebID
		ORDER BY Pag.ClienteID, Tar.TarjetaDebID, Tar.FPagoComAnual;

END IF;



END TerminaStore$$