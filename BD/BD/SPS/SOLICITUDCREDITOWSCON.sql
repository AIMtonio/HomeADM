-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOWSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOWSCON`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDCREDITOWSCON`(
	Par_SoliCredID      bigint(20),
    Par_NumCon          tinyint unsigned,
	Par_InstitNominaID  int,
	Par_NegocioAfID		int,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN


DECLARE Con_FechaVacia          date;
DECLARE Decimal_Cero            decimal(12,2);
DECLARE Entero_Cero             int;
DECLARE Con_StrVacio            char(1);
DECLARE Con_Principal           int;
DECLARE Con_ExisCre             int;
DECLARE Con_ClienCre            int;
DECLARE Con_EmpleadoNomina      int;


Set Con_FechaVacia      := '1900-01-01';
Set Decimal_Cero        := 0.0;
Set Entero_Cero         := 0;
Set Con_StrVacio        := '';
Set Con_Principal       := 6;
Set Con_ExisCre         := 7;
Set Con_ClienCre        := 8;
Set Con_EmpleadoNomina  := 9;
if(Par_NumCon = Con_Principal) then

	select  Sol.SolicitudCreditoID, ifnull(Sol.ClienteID,Entero_Cero) as ClienteID,
            ifnull(Cli.NombreCompleto, Con_StrVacio) as CliNombreCompleto,
			ifnull(Sol.ProspectoID,Entero_Cero) as ProspectoID,
            ifnull(Pro.NombreCompleto, Con_StrVacio) as ProNombreCompleto,
			Sol.ProductoCreditoID,  Prod.Descripcion,  Sol.FechaRegistro,      Sol.Estatus,
			Sol.Proyecto,
            Sol.MontoSolici,        Sol.CuentaCLABE,      Sol.FechaInicio,
			Sol.FechaVencimiento,	Sol.ForCobroComAper,  Sol.MontoPorComAper,
			Sol.PlazoID, 			Sol.FrecuenciaCap,	  Sol.NumAmortizacion,
			Sol.ValorCAT
    from SOLICITUDCREDITO Sol
		 left join  CLIENTES Cli             on Sol.ClienteID = Cli.ClienteID
		 left join  PROSPECTOS Pro           on Sol.ProspectoID = Pro.ProspectoID
	     inner join SOLICITUDCREDITOBE SolBE on Sol.SolicitudCreditoID= SolBE.SolicitudCreditoID
		 inner join PRODUCTOSCREDITO Prod on Sol.ProductoCreditoID= Prod.ProducCreditoID
	where Sol.SolicitudCreditoID = Par_SoliCredID ;
end if;

if (Par_numCon = Con_ExisCre) then
    select CreditoID from SOLICITUDCREDITOBE Sbe
    INNER JOIN CREDITOS Cre ON Sbe.SolicitudCreditoID= Cre.SolicitudCreditoID
    where Cre.CreditoID=Par_SoliCredID and Sbe.InstitNominaID=Par_InstitNominaID;
end if;

if(Par_numCon = Con_ClienCre) then
    SELECT Cre.ClienteID FROM CREDITOS Cre
    INNER JOIN SOLICITUDCREDITOBE Sbe
     ON Sbe.SolicitudCreditoID= Cre.SolicitudCreditoID
            WHERE Sbe.InstitNominaID=Par_InstitNominaID
                AND Cre.CreditoID=Par_SoliCredID;
end if;

if(Par_numCon = Con_EmpleadoNomina) then
	SELECT Sol.FolioCtrl
		FROM CREDITOS Cre
		INNER JOIN SOLICITUDCREDITO Sol
			ON Sol.SolicitudCreditoID=Cre.SolicitudCreditoID
            WHERE Sol.InstitucionNominaID=Par_InstitNominaID
                AND Cre.CreditoID=Par_SoliCredID;
end if;

END TerminaStore$$