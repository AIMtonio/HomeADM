-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICICREDITOWSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICICREDITOWSREP`;DELIMITER $$

CREATE PROCEDURE `SOLICICREDITOWSREP`(
	Par_NegocioAfiliadoID	int,
	Par_InstitNominaID		int,
	Par_ClienteID			int,
	Par_ProspectoID			int,
	Par_SolEstatus			char(1),
	Par_TipoReporte			int,

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore:BEGIN

-- Declaración de Variables

-- Declaracion de Constantes
DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia	char;
DECLARE Rep_NegAfilia	int;
DECLARE Rep_EmpNomina	int;
DECLARE Rep_PFyPM		int;
DECLARE Sta_Inactiva	char(1);
DECLARE Sta_Liberada	char(1);
DECLARE Sta_Autoriza	char(1);
DECLARE Sta_Desemb		char(1);
DECLARE Sta_Cancelada	char(1);
DECLARE Sta_Rechazada	char(1);
DECLARE Sta_PorAutori	char(1);

-- Asignacion de Constantes
set	Entero_Cero		:= 0;			-- Entero Cero
set	Cadena_Vacia	:= '';			-- Cadena Vacia
set	Rep_NegAfilia	:= 1;			-- Tipo de Reporte de Negocio Afiliado
set	Rep_EmpNomina	:= 2;			-- Tipo de Reporte de Empresa de Nomina
set	Rep_PFyPM		:= 3;			-- Tipo de Reporte de Persona Fisica y Moral

set	Sta_Inactiva	:= 'I';			-- Estatus de la Solicitud Inactiva
set	Sta_Liberada	:= 'L';			-- Estatus de la Solicitud Liberada
set	Sta_Autoriza	:= 'A';			-- Estatus de la Solicitud Autorizada
set	Sta_Desemb		:= 'D';			-- Estatus de la Solicitud Desembolsada
set	Sta_Cancelada	:= 'C';			-- Estatus de la Solicitud Cancelada
set	Sta_Rechazada	:= 'R';			-- Estatus de la Solicitud Rechazada
set	Sta_PorAutori	:= 'P';			-- Estatus de la Solicitud Por Autorizar


-- Inicializacion
set	Par_NegocioAfiliadoID	:= ifnull(Par_NegocioAfiliadoID, Entero_Cero);
set	Par_InstitNominaID		:= ifnull(Par_InstitNominaID, Entero_Cero);
set	Par_ClienteID			:= ifnull(Par_ClienteID, Entero_Cero);
set	Par_ProspectoID			:= ifnull(Par_ProspectoID, Entero_Cero);

if(Par_TipoReporte = Rep_NegAfilia) then

	(select	convert(Sol.SolicitudCreditoID, char) as SolicitudID,
			concat(convert(Cli.ClienteID, char), '-', Cli.NombreCompleto) as Cliente,
			concat(convert(Prod.ProducCreditoID, char), '-', Prod.Descripcion) as ProductoCredito,
			convert(Sol.FechaRegistro, char(10)) as FechaSolicitud,
			format(Sol.MontoSolici,2) as MontoSolicitado,
			Pro.NombrePromotor as NombrePromotor,
			Pro.Telefono as TelPromotor
		from SOLICITUDCREDITO Sol,
			 CLIENTES Cli,
			 PROMOTORES Pro,
			 PRODUCTOSCREDITO Prod,
			 SOLICITUDCREDITOBE Ban
			where Cli.ClienteID = Par_ClienteID
			  and Sol.ClienteID = Cli.ClienteID
			  and Cli.PromotorActual = Pro.PromotorID
			  and Sol.ProductoCreditoID = Prod.ProducCreditoID
			  and Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
			  and Ban.NegocioAfiliadoID = Par_NegocioAfiliadoID
			  and (	(	Par_SolEstatus = Sta_Autoriza
			  and  		Sol.Estatus in (Sta_Autoriza, Sta_Desemb) )
			  or     (	Par_SolEstatus = Sta_Rechazada
			  and  		Sol.Estatus in (Sta_Rechazada, Sta_Cancelada) )
			  or     (	Par_SolEstatus = Sta_PorAutori
			  and  		Sol.Estatus in (Sta_Inactiva, Sta_Liberada) )	))

		union
		(select	convert(Sol.SolicitudCreditoID, char) as SolicitudID,
				concat(convert(Pros.ProspectoID, char), '-', Pros.NombreCompleto) as Cliente,
				concat(convert(Prod.ProducCreditoID, char), '-', Prod.Descripcion) as ProductoCredito,
				convert(Sol.FechaRegistro, char(10)) as FechaSolicitud,
				format(Sol.MontoSolici,2) as MontoSolicitado,
				Suc.NombreGerente as NombrePromotor,
				Suc.Telefono as TelPromotor
			from SOLICITUDCREDITO Sol,
				 PROSPECTOS Pros,
				 SUCURSALES Suc,
				 PRODUCTOSCREDITO Prod,
				 SOLICITUDCREDITOBE Ban
				where Pros.ProspectoID = Par_ProspectoID
				  and ifnull(Pros.ClienteID, Entero_Cero) <= Entero_Cero
				  and Sol.ProspectoID = Pros.ProspectoID
				  and Sol.SucursalID = Suc.SucursalID
				  and Sol.ProductoCreditoID = Prod.ProducCreditoID
				  and Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
				  and Ban.NegocioAfiliadoID = Par_NegocioAfiliadoID
				  and (	(	Par_SolEstatus = Sta_Autoriza
				  and  		Sol.Estatus in (Sta_Autoriza, Sta_Desemb) )
				   or     (	Par_SolEstatus = Sta_Rechazada
				  and  		Sol.Estatus in (Sta_Rechazada, Sta_Cancelada) )
				   or     (	Par_SolEstatus = Sta_PorAutori
				  and  		Sol.Estatus in (Sta_Inactiva, Sta_Liberada) )	));

end if;

if(Par_TipoReporte = Rep_EmpNomina) then

	(select	convert(Sol.SolicitudCreditoID, char) as SolicitudID,
			concat(convert(Cli.ClienteID, char), '-', Cli.NombreCompleto) as Cliente,
			concat(convert(Prod.ProducCreditoID, char), '-', Prod.Descripcion) as ProductoCredito,
			convert(Sol.FechaRegistro, char(10)) as FechaSolicitud,
			format(Sol.MontoSolici,2) as MontoSolicitado,
			Pro.NombrePromotor as NombrePromotor,
			Pro.Telefono as TelPromotor
		from SOLICITUDCREDITO Sol,
			 CLIENTES Cli,
			 PROMOTORES Pro,
			 PRODUCTOSCREDITO Prod,
			 SOLICITUDCREDITOBE Ban
			where Cli.ClienteID = Par_ClienteID
			  and Sol.ClienteID = Cli.ClienteID
			  and Cli.PromotorActual = Pro.PromotorID
			  and Sol.ProductoCreditoID = Prod.ProducCreditoID
			  and Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
			  and Ban.InstitNominaID = Par_InstitNominaID
			  and (	(	Par_SolEstatus = Sta_Autoriza
			  and  		Sol.Estatus in (Sta_Autoriza, Sta_Desemb) )
			  or     (	Par_SolEstatus = Sta_Rechazada
			  and  		Sol.Estatus in (Sta_Rechazada, Sta_Cancelada) )
			  or     (	Par_SolEstatus = Sta_PorAutori
			  and  		Sol.Estatus in (Sta_Inactiva, Sta_Liberada) )	))

		union
		(select	convert(Sol.SolicitudCreditoID, char) as SolicitudID,
				concat(convert(Pros.ProspectoID, char), '-', Pros.NombreCompleto) as Cliente,
				concat(convert(Prod.ProducCreditoID, char), '-', Prod.Descripcion) as ProductoCredito,
				convert(Sol.FechaRegistro, char(10)) as FechaSolicitud,
				format(Sol.MontoSolici,2) as MontoSolicitado,
				Suc.NombreGerente as NombrePromotor,
				Suc.Telefono as TelPromotor
			from SOLICITUDCREDITO Sol,
				 PROSPECTOS Pros,
				 SUCURSALES Suc,
				 PRODUCTOSCREDITO Prod,
				 SOLICITUDCREDITOBE Ban
				where Pros.ProspectoID = Par_ProspectoID
				  and ifnull(Pros.ClienteID, Entero_Cero) <= Entero_Cero
				  and Sol.ProspectoID = Pros.ProspectoID
				  and Sol.SucursalID = Suc.SucursalID
				  and Sol.ProductoCreditoID = Prod.ProducCreditoID
				  and Sol.SolicitudCreditoID = Ban.SolicitudCreditoID
				  and Ban.InstitNominaID = Par_InstitNominaID
				  and (	(	Par_SolEstatus = Sta_Autoriza
				  and  		Sol.Estatus in (Sta_Autoriza, Sta_Desemb) )
				   or     (	Par_SolEstatus = Sta_Rechazada
				  and  		Sol.Estatus in (Sta_Rechazada, Sta_Cancelada) )
				   or     (	Par_SolEstatus = Sta_PorAutori
				  and  		Sol.Estatus in (Sta_Inactiva, Sta_Liberada) )	));

end if;


if(Par_TipoReporte = Rep_PFyPM) then

	(select	convert(Sol.SolicitudCreditoID, char) as SolicitudID,
			concat(convert(Cli.ClienteID, char), '-', Cli.NombreCompleto) as Cliente,
			concat(convert(Prod.ProducCreditoID, char), '-', Prod.Descripcion) as ProductoCredito,
			convert(Sol.FechaRegistro, char(10)) as FechaSolicitud,
			format(Sol.MontoSolici,2) as MontoSolicitado,
			Pro.NombrePromotor as NombrePromotor,
			Pro.Telefono as TelPromotor
		from SOLICITUDCREDITO Sol,
			 CLIENTES Cli,
			 PROMOTORES Pro,
			 PRODUCTOSCREDITO Prod
			where Cli.ClienteID = Par_ClienteID
			  and Sol.ClienteID = Cli.ClienteID
			  and Cli.PromotorActual = Pro.PromotorID
			  and Sol.ProductoCreditoID = Prod.ProducCreditoID
			  and (	(	Par_SolEstatus = Sta_Autoriza
			  and  		Sol.Estatus in (Sta_Autoriza, Sta_Desemb) )
			  or     (	Par_SolEstatus = Sta_Rechazada
			  and  		Sol.Estatus in (Sta_Rechazada, Sta_Cancelada) )
			  or     (	Par_SolEstatus = Sta_PorAutori
			  and  		Sol.Estatus in (Sta_Inactiva, Sta_Liberada) )	))

		union
		(select	convert(Sol.SolicitudCreditoID, char) as SolicitudID,
				concat(convert(Pros.ProspectoID, char), '-', Pros.NombreCompleto) as Cliente,
				concat(convert(Prod.ProducCreditoID, char), '-', Prod.Descripcion) as ProductoCredito,
				convert(Sol.FechaRegistro, char(10)) as FechaSolicitud,
				format(Sol.MontoSolici,2) as MontoSolicitado,
				Suc.NombreGerente as NombrePromotor,
				Suc.Telefono as TelPromotor
			from SOLICITUDCREDITO Sol,
				 PROSPECTOS Pros,
				 SUCURSALES Suc,
				 PRODUCTOSCREDITO Prod
				where Pros.ProspectoID = Par_ProspectoID
				  and ifnull(Pros.ClienteID, Entero_Cero) <= Entero_Cero
				  and Sol.ProspectoID = Pros.ProspectoID
				  and Sol.SucursalID = Suc.SucursalID
				  and Sol.ProductoCreditoID = Prod.ProducCreditoID
				  and (	(	Par_SolEstatus = Sta_Autoriza
				  and  		Sol.Estatus in (Sta_Autoriza, Sta_Desemb) )
				   or     (	Par_SolEstatus = Sta_Rechazada
				  and  		Sol.Estatus in (Sta_Rechazada, Sta_Cancelada) )
				   or     (	Par_SolEstatus = Sta_PorAutori
				  and  		Sol.Estatus in (Sta_Inactiva, Sta_Liberada) )	));

end if;

END TerminaStore$$