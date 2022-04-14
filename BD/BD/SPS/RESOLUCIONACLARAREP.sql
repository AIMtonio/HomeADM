-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESOLUCIONACLARAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESOLUCIONACLARAREP`;DELIMITER $$

CREATE PROCEDURE `RESOLUCIONACLARAREP`(
	Par_ReporteID       varchar(22),
	Par_TarjetaDebID    char(16),
    Par_NumRep          tinyint unsigned,

    Par_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Rep_ResAclara   int(11);


Set Rep_ResAclara   := 1;

if(Par_NumRep = Rep_ResAclara) then
	SELECT
		LPAD(convert(Tarj.ClienteID, CHAR),10,0) as ClienteID,	Tarj.TarjetaDebID,	Tarj.NombreTarjeta,
        Tar.DetalleReporte,		Tar.FechaAclaracion,	Ope.Descripcion,	Tar.Comercio, 	Tar.FechaOperacion,
		Tar.UsuarioResolucion,	concat(US.ApPaterno," ", US.ApMaterno, " ", US.Nombre) as NombreCompleto, 		Cli.Telefono, 		Suc.NombreSucurs,
		CONCAT("Con base en la cláusula Trigésima Primera, Fracción III del contrato  de la Tarjeta Débito Yanga. \n \n Se emite el siguiente dictamen: ",
				" Derivado de la solicitud de aclaración recibida con fecha ", DAY(FechaAclaracion), " de ",
				CASE MONTH(FechaAclaracion)	WHEN '01' THEN 'Enero'	WHEN '02' THEN 'Febrero' WHEN '03' THEN 'Marzo'	WHEN '04' THEN 'Abril'
				WHEN '05' THEN 'Mayo' WHEN '06' THEN 'Junio' WHEN '07' THEN 'Julio' WHEN '08' THEN 'Agosto'	WHEN '09' THEN 'Septiembre'
				WHEN '10' THEN 'Octubre' WHEN '11' THEN 'Noviembre'	WHEN '12' THEN 'Diciembre' END , " del ", YEAR(FechaAclaracion),
				" realizada por el socio arriba mencionado, se libera la siguiente resolución ", Tar.DetalleResolucion,
				" por concepto de ", Descripcion," en ",
				CASE Tar.TipoAclaraID WHEN 1 THEN Comercio WHEN 2 THEN concat("Cajero No. " , NoCajero) END ,", del día ",DAY(FechaOperacion)," de ",
				CASE MONTH(FechaOperacion)
				WHEN '01' THEN 'Enero'	WHEN '02' THEN 'Febrero' WHEN '03' THEN 'Marzo'	WHEN '04' THEN 'Abril'
				WHEN '05' THEN 'Mayo' WHEN '06' THEN 'Junio' WHEN '07' THEN 'Julio' WHEN '08' THEN 'Agosto'	WHEN '09' THEN 'Septiembre'
				WHEN '10' THEN 'Octubre' WHEN '11' THEN 'Noviembre'	WHEN '12' THEN 'Diciembre' END,
				" del ",YEAR(FechaOperacion), ". \n \n El tarjetahabiente firmará los documentos emitidos por la Entidad, para el pago correspondiente. Y sólo se proporcionará copia del ticket emitido en el área de cajas en ventanilla.") as DetalleResolucion
	FROM TARDEBACLARACION as Tar
	INNER JOIN TARJETADEBITO as Tarj on Tarj.TarjetaDebID=Tar.TarjetaDebID
	INNER JOIN TARDEBOPEACLARA as Ope on Ope.TipoAclaraID=Tar.TipoAclaraID and Ope.OpeAclaraID=Tar.OpeAclaraID
	INNER JOIN USUARIOS as US on Tar.UsuarioResolucion=US.UsuarioID
	INNER JOIN CLIENTES as Cli on Tarj.ClienteID = Cli.ClienteID
	INNER JOIN SUCURSALES as Suc on Cli.SucursalOrigen = Suc.SucursalID
	WHERE Tar.TarjetaDebID = Par_TarjetaDebID AND Tar.ReporteID = Par_ReporteID;
end if;

END TerminaStore$$