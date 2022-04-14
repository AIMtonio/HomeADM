-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APPWTARJETACREDDEBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APPWTARJETACREDDEBLIS`;

DELIMITER $$
CREATE PROCEDURE `APPWTARJETACREDDEBLIS`(

	Par_ClienteID		INT(11),
	Par_NumLis		    TINYINT UNSIGNED,

    Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(12)
	)

TerminaStore: BEGIN


	DECLARE Var_NombreComp				VARCHAR(200);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Entero_Uno			INT(11);
	DECLARE	Lis_Principal		INT(11);

	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia 		:= '1900-01-01';
	SET	Entero_Cero	    	:= 0;
	SET Entero_Uno			:= 1;
	SET	Lis_Principal		:= 1;


	IF(Par_NumLis = Lis_Principal) THEN

		SELECT NombreCompleto INTO Var_NombreComp FROM CLIENTES WHERE ClienteID = Par_ClienteID;

		SELECT 	TAR.TarjetaDebID AS TarjetaID, 		TAR.ClienteID AS ClienteID, 		Var_NombreComp As Nombre, 		CUE.Saldo AS Saldo,
				CUE.SaldoBloq As SaldoBloq, 		CUE.SaldoDispon AS SaldoDisp, 		TAR.Estatus As Estatus, 		TAR.FechaVencimiento AS FechaVenc,
				TIP.ImagenFonTar,					IF(TAR.Estatus = 8, 'S', 'N') AS Apagado, 'D' As TipoTar
			FROM TARJETADEBITO TAR
			INNER JOIN CUENTASAHO CUE ON CUE.CuentaAhoID = TAR.CuentaAhoID
			INNER JOIN TIPOTARJETADEB TIP ON TIP.TipoTarjetaDebID = TAR.TipoTarjetaDebID
			WHERE TAR.ClienteID = Par_ClienteID
		UNION
		SELECT  TARC.TarjetaCredID AS TarjetaID, 	TARC.ClienteID AS ClienteID, 		Var_NombreComp As Nombre, 		(IFNULL(LIN.SaldoCapVigente, 0) + IFNULL(LIN.SalOrtrasComis, 0)) AS Saldo,
				LIN.MontoBloqueado As SaldoBloq, 	LIN.MontoDisponible AS SaldoDisp,	TARC.Estatus As Estatus, 		TARC.FechaVencimiento AS FechaVenc,
				TIP.ImagenFonTar,					IF(TARC.Estatus = 8, 'S', 'N') AS Apagado, 'C' As TipoTar
			FROM TARJETACREDITO TARC
			INNER JOIN LINEATARJETACRED LIN ON TARC.LineaTarCredID = LIN.LineaTarCredID
			INNER JOIN TIPOTARJETADEB TIP ON TIP.TipoTarjetaDebID = TARC.TipoTarjetaCredID
			WHERE TARC.ClienteID = Par_ClienteID;

	END IF;

END TerminaStore$$