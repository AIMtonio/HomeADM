-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FONDEOSOLICITUDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FONDEOSOLICITUDLIS`;DELIMITER $$

CREATE PROCEDURE `FONDEOSOLICITUDLIS`(
    Par_SolicCredID     BIGINT(20),
    Par_NumLis          tinyint unsigned,
    Par_EmpresaID       int(11),

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN


DECLARE Sum_Monto       int;
DECLARE Sum_Porcen      decimal(12,2);
DECLARE Margen          decimal(12,4);


DECLARE Entero_Cero     int;
DECLARE Lis_Principal   int;
DECLARE Lis_GridFond    int;
DECLARE Lis_Inver       int;
DECLARE Lis_AltoRiesgo  int;
DECLARE Alto_Riesgo     char(1);



set Entero_Cero     := 0;
set Lis_Principal   := 1;
set Lis_GridFond    := 2;
set Lis_Inver       := 3;
set Lis_AltoRiesgo  := 4;
set Alto_Riesgo     := 'A';


if(Par_NumLis = Lis_GridFond) then

	select	SUM(MontoFondeo), SUM(PorcentajeFOndeo)
			into
			Sum_Monto,         Sum_Porcen
		from  FONDEOSOLICITUD
		where SolicitudCreditoID  like concat("%", Par_SolicCredID, "%");


	select	Fon.SolicitudCreditoID,  Fon.Consecutivo,		Cli.NombreCompleto as ClienteID,		Fon.FechaRegistro,
			CONCAT(FORMAT(Fon.MontoFondeo,2)),		   		CONCAT(FORMAT(Fon.PorcentajeFondeo,2)),   Fon.TasaPasiva,
			CONCAT(FORMAT(Sum_Monto,2)),  					CONCAT(FORMAT(Sum_Porcen,2)),
			CONCAT(FORMAT(Fon.TasaActiva-Fon.TasaPasiva,2))as Margen

		from FONDEOSOLICITUD Fon,
			 CLIENTES Cli
		where SolicitudCreditoID  like concat("%", Par_SolicCredID, "%")
		and	  Fon.ClienteID = Cli.ClienteID;
end if;


if(Par_NumLis = Lis_Inver) then

select   Fon.FondeoKuboID,   Fon.ClienteID,		Cli.NombreCompleto,	CONCAT(FORMAT(Fon.MontoFondeo,2)),
		CONCAT(FORMAT(Fon.PorcentajeFondeo,2)),	 Fon.TasaPasiva
		from FONDEOSOLICITUD Fon,
			 CLIENTES Cli
		where SolicitudCreditoID  like concat("%", Par_SolicCredID, "%")
		and	  Fon.ClienteID = Cli.ClienteID
		limit 0, 15;
end if;


if(Par_NumLis = Lis_AltoRiesgo) then

    select  SolFondeoID, Fon.ClienteID, Cli.NombreCompleto, Cli.RFCOficial, FechaRegistro,
            FORMAT(Fon.MontoFondeo,2),
            FORMAT(Fon.PorcentajeFondeo,2),
            Cli.NivelRiesgo
            from FONDEOSOLICITUD Fon,
                 CLIENTES Cli
            where SolicitudCreditoID  = Par_SolicCredID
              and Fon.ClienteID       = Cli.ClienteID
              and Cli.NivelRiesgo     = Alto_Riesgo;

end if;

END TerminaStore$$