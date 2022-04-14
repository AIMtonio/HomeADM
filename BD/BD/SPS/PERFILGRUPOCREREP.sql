-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERFILGRUPOCREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERFILGRUPOCREREP`;DELIMITER $$

CREATE PROCEDURE `PERFILGRUPOCREREP`(
	Par_GrupoID			int,

	Aud_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN





DECLARE CadenaVacia          char(1);
DECLARE EnteroCero           int;
DECLARE FechaVacia           DATE;
DECLARE CargoPresidente      int;
DECLARE CargoSecretario      int;
DECLARE CargoTesorero        int;
DECLARE CargoIntegrante      int;
DECLARE CuentaActiva         char(1);


Set CadenaVacia             := '';
Set EnteroCero              := 0;
Set FechaVacia              := '1900-01-01';
Set CargoPresidente         := 1;
Set CargoSecretario         := 2;
Set CargoTesorero           := 3;
Set CargoIntegrante         := 4;
Set CuentaActiva            := 'A';



select  Inte.ClienteID,
        concat(Cli.PrimerNombre,
                    (case when ifnull(Cli.SegundoNombre, '') != '' then concat(' ', Cli.SegundoNombre)
                                                                else CadenaVacia
                     end),
                    (case when ifnull(Cli.TercerNombre, '') != '' then  concat(' ', Cli.TercerNombre)
                                                               else CadenaVacia
                     end), ' ',
                Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno) as NombreCliente,
        Inte.FechaRegistro,
        case when Inte.Cargo = CargoPresidente  then 'PRESIDENTE(A)'
             when Inte.Cargo = CargoSecretario  then 'SECRETARIO(A)'
             when Inte.Cargo = CargoTesorero    then 'TESORERO(A)'
                                                else 'INTEGRANTE'
        end as Puesto,
        Case when Inte.Estatus = 'A' then 'ACTIVO'
             when Inte.Estatus = 'I' then 'INACTIVO'
             when Inte.Estatus = 'R' then 'RECHAZADO'
                                     else 'NO DEFINIDO'
        end as Estado,
        Cue.CuentaAhoID,
        Cue.Etiqueta,
        Cue.Saldo,
        Cue.SaldoDispon,
        Cue.SaldoBloq
from 	INTEGRAGRUPOSCRE Inte
inner join CLIENTES Cli on Cli.ClienteID = Inte.ClienteID
inner join CUENTASAHO Cue on Cue.ClienteID = Inte.ClienteID
where  Inte.GrupoID = Par_GrupoID
  and  Cue.Estatus = CuentaActiva
order by Inte.Cargo, Cue.Etiqueta, Cue.CuentaAhoID;



END TerminaStore$$