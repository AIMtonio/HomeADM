-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CINTAINTF
DELIMITER ;
DROP FUNCTION IF EXISTS `CINTAINTF`;
DELIMITER $$

CREATE FUNCTION `CINTAINTF`(
	FechaCorteBC date,
	Member varchar(10),
	NombreEmp varchar(100)
) RETURNS varchar(1000) CHARSET latin1
	DETERMINISTIC
BEGIN
DECLARE TEST varchar(20);
DECLARE ETIQUETA varchar(02);
DECLARE CINTA varchar(500);
DECLARE LONGITUD decimal;
declare VAR_ClienteID int;
declare VAR_ApellidoPaterno varchar(40);
declare VAR_ApellidoMaterno	varchar(40);
declare VAR_Adicional	varchar(40);
declare VAR_PrimerNombre	varchar(40);
declare VAR_Segundo	varchar(40);
declare VAR_FechaNacimiento	varchar(40);
declare VAR_RFC varchar(40);
declare VAR_Prefijo varchar(40);
declare VAR_EstadoCivil	varchar(40);
declare VAR_Sexo	varchar(40);
declare VAR_FDef	varchar(40);
declare VAR_InDef	varchar(40);
declare VAR_CalleNumero	varchar(40);
declare VAR_Colonia	varchar(40);
declare VAR_Municipio	varchar(40);
declare VAR_estado	varchar(40);
declare VAR_CP	 varchar(40);
declare VAR_Telefono varchar(40);
declare VAR_member	varchar(40);
declare VAR_nombre	varchar(40);
declare VAR_Cuenta	varchar(40);
declare VAR_Responsabilidad	varchar(40);
declare VAR_TipoCuenta	 varchar(40);
declare VAR_TipoContrato	varchar(40);
declare VAR_Moneda	varchar(40);
declare VAR_NPagos	varchar(40);
declare VAR_FrecPagos	varchar(40);
declare VAR_saldo	varchar(40);
declare VAR_vencido	varchar(40);
declare VAR_FechaInicio	varchar(40);
declare VAR_MontoCredito	varchar(40);
declare VAR_ImportePagos	varchar(40);
declare VAR_Incumplimiento varchar(40);
declare VAR_LimiteCred varchar(40);
declare VAR_FechaCompra varchar(40);
declare VAR_FechaReporte varchar(40);
declare VAR_FechaCierre varchar(3);
declare VAR_NPagosVencidos varchar(3);
declare VAR_NDiasAtraso varchar(3);
declare VAR_MOP varchar(3);
declare VAR_UltimoPago varchar(8);
declare VAR_SVigente int(14) default 0;
declare VAR_SVencido int(14) default 0;
declare VAR_NSegmentos int(5) default 0;
DECLARE hayRegistros boolean default true;



  DECLARE CUR1 CURSOR FOR
select CLIENTES.ClienteID,
    ApellidoPaterno ,
    ApellidoMaterno,
    '' as Adicional,
    PrimerNombre,
    concat(SegundoNombre, ' ', TercerNombre) as Segundo,
     Date_format(FechaNacimiento,'%d%m%Y')as FechaNacimiento,
    RFC,
    Titulo as Prefijo,
    EstadoCivil,
    Sexo,
    '' as FDef,
    '' as InDef,
    concat(Calle, ' ', NumeroCasa) as CalleNumero,
    Colonia,
    MUNICIPIOSREPUB.Nombre as Municipio,
    ESTADOSREPUB.EqBuroCred as estado,
    CP,
    Telefono,
    '' as member,
    '' as nombre,
    CREDITOS.CreditoID as Cuenta,
    if(EsGrupal = 'S', 'J', 'I') as Responsabilidad,
    if(EsRevolvente = 'S', 'R', 'I') as TipoCuenta,
'PL'as TipoContrato ,
MONEDAS.EqBuroCred as Moneda,
CREDITOS.NumAmortizacion as NPagos,
CREDITOS.FrecuenciaCap as FrecPagos,
round((salCapVigente+SalCapAtrasado+SalCapVencido))as saldo,
round((salCapAtrasado+SalCapVencido))as vencido,
  Date_format(CREDITOS.FechaInicio,'%d%m%Y')as FechaInicio,
round(CREDITOS.MontoCredito) as MontoCredito,
round(FUNCIONEXIGIBLECAP(CREDITOS.CreditoID,FechaCorteBC))as ImportePagos,
Date_format(Incumplimiento,'%d%m%Y')as Incumplimiento,
if (FechaLiquida='1900-01-01','',Date_format(FechaLiquida,'%d%m%Y'))as FechaCierre,
NoCuotasAtraso,
DiasAtraso,
coalesce(Date_format(UltimoPago,'%d%m%Y'),''),
if(DiasAtraso>=360,'96',if(DiasAtraso>=150,'07',if(DiasAtraso>=120,'06',if(DiasAtraso>=90,'05',if(DiasAtraso>=60,'04',if(DiasAtraso>=30,'03',if(DiasAtraso>=01,'02','01')))))))as MOP
from   (select CreditoID,max(FechaPago)as UltimoPago from DETALLEPAGCRE group by CreditoID)as pagos right join ( (select CreditoId,min(FechaCorte)as Incumplimiento from SALDOSCREDITOS where  salCapAtrasado<>0 group by CreditoID)
as Incumplimiento inner join(
(select CreditoId,min(AmortizacionID)as vencimiento,capital as SiguientePago
from AMORTICREDITO where FechaExigible >=FechaCorteBC and Estatus='V' group by CreditoID)
as SiguientePago inner join (
MONEDAS inner join
    (PRODUCTOSCREDITO
        inner join (SALDOSCREDITOS inner join
    (CREDITOS
    inner join (CLIENTES
    inner join (DIRECCLIENTE
    inner join (MUNICIPIOSREPUB
    inner join ESTADOSREPUB
ON MUNICIPIOSREPUB.EstadoID = ESTADOSREPUB.EstadoID)
ON DIRECCLIENTE.MunicipioID = MUNICIPIOSREPUB.MunicipioID  and DIRECCLIENTE.EstadoID=MUNICIPIOSREPUB.EstadoID )
ON CLIENTES.ClienteID = DIRECCLIENTE.ClienteID)
ON CREDITOS.ClienteID = CLIENTES.ClienteID)
On SALDOSCREDITOS.CreditoID=CREDITOS.CreditoID)
ON PRODUCTOSCREDITO.ProducCreditoID = CREDITOS.ProductoCreditoID)
on CREDITOS.MonedaID=MONEDAS.MonedaId)
On SiguientePago.CreditoID=CREDITOS.CreditoID)
on Incumplimiento.CreditoID=CREDITOS.CreditoID) on pagos.CreditoId=CREDITOS.CreditoID
where
    DIRECCLIENTE.Oficial = 'S'
and
SALDOSCREDITOS.FechaCorte=FechaCorteBC;


    DECLARE CONTINUE HANDLER FOR SQLSTATE '02000' SET hayRegistros=false;

delete FROM BUROCREDINTF where Fecha=FechaCorteBC and CintaID>0;

select RPAD(concat('INTF11',`Member`,RPAD(NombreEmp,16,' '),'  ',Date_format(FechaCorteBC,'%d%m%Y'),'0000000000'),150,' ')as encabezado into CINTA;
insert into BUROCREDINTF (ClienteID,Clave,Fecha,Cinta)values (0,`Member`,FechaCorteBC,CINTA);

OPEN CUR1;
FETCH CUR1 INTO  VAR_ClienteID ,VAR_ApellidoPaterno ,VAR_ApellidoMaterno,VAR_Adicional,VAR_PrimerNombre,VAR_Segundo,VAR_FechaNacimiento,VAR_RFC,VAR_Prefijo,VAR_EstadoCivil,VAR_Sexo,VAR_FDef,VAR_InDef,VAR_CalleNumero,VAR_Colonia,VAR_Municipio,	VAR_estado,VAR_CP,VAR_Telefono,VAR_member,	VAR_nombre,VAR_Cuenta,VAR_Responsabilidad,VAR_TipoCuenta,	VAR_TipoContrato,	VAR_Moneda,	VAR_NPagos,VAR_FrecPagos,	VAR_saldo,	VAR_vencido,VAR_FechaInicio,VAR_MontoCredito,VAR_ImportePagos,VAR_Incumplimiento,VAR_FechaCierre,VAR_NPagosVencidos,VAR_NDiasAtraso,VAR_UltimoPago,VAR_MOP;

WHILE hayRegistros DO
SET VAR_SVigente=VAR_SVigente+Var_saldo;
SET VAR_SVencido=VAR_SVencido + Var_vencido;
SET VAR_NSegmentos=VAR_NSegmentos+1;

SET VAR_ApellidoPaterno := trim(concat('PN', LPAD(character_length(TRIM(VAR_ApellidoPaterno)),2,'0'),VAR_ApellidoPaterno)) ;
SET VAR_ApellidoMaterno := trim(concat('00', LPAD(character_length(TRIM(VAR_ApellidoMaterno)),2,'0'),VAR_ApellidoMaterno)) ;
SET VAR_PrimerNombre := trim(concat('02', LPAD(character_length(TRIM(VAR_PrimerNombre)),2,'0'),VAR_PrimerNombre) );
SET VAR_Segundo := trim(concat('03', LPAD(character_length(TRIM(VAR_Segundo)),2,'0'),VAR_Segundo)) ;
SET VAR_FechaNacimiento := trim(concat('04', LPAD(character_length(TRIM(VAR_FechaNacimiento)),2,'0'),VAR_FechaNacimiento)) ;
SET VAR_RFC := trim(concat('05', LPAD(character_length(TRIM(VAR_RFC)),2,'0'),VAR_RFC)) ;
SET VAR_EstadoCivil := trim(concat('11', LPAD(character_length(TRIM(VAR_EstadoCivil)),2,'0'),VAR_EstadoCivil)) ;
SET VAR_Sexo := trim(concat('12', LPAD(character_length(TRIM(VAR_Sexo)),2,'0'),VAR_Sexo)) ;
SET VAR_CalleNumero := trim(concat('PA', LPAD(character_length(TRIM(VAR_CalleNumero)),2,'0'),VAR_CalleNumero)) ;
SET VAR_Colonia := trim(concat('01', LPAD(character_length(TRIM(VAR_Colonia)),2,'0'),VAR_Colonia)) ;
SET VAR_Municipio := trim(concat('02', LPAD(character_length(TRIM(VAR_Municipio)),2,'0'),VAR_Municipio)) ;
SET VAR_estado := trim(concat('04', LPAD(character_length(TRIM(VAR_estado)),2,'0'),VAR_estado)) ;
SET VAR_CP := trim(concat('05', LPAD(character_length(TRIM(VAR_CP)),2,'0'),VAR_CP)) ;
SET VAR_member := concat('TL02TL01',LPAD(character_length(TRIM(`Member`)),2,'0'),`Member`);
SET VAR_nombre := trim(concat('02', LPAD(character_length(TRIM(NombreEmp)),2,'0'),NombreEmp)) ;
SET VAR_Cuenta := trim(concat('04', LPAD(character_length(TRIM(VAR_Cuenta)),2,'0'),VAR_Cuenta)) ;
SET VAR_Responsabilidad := trim(concat('05', LPAD(character_length(TRIM(VAR_Responsabilidad)),2,'0'),VAR_Responsabilidad)) ;
SET VAR_TipoCuenta := trim(concat('06', LPAD(character_length(TRIM(VAR_TipoCuenta)),2,'0'),VAR_TipoCuenta)) ;
SET VAR_TipoContrato := trim(concat('07', LPAD(character_length(TRIM(VAR_TipoContrato)),2,'0'),VAR_TipoContrato)) ;
SET VAR_Moneda := trim(concat('08', LPAD(character_length(TRIM(VAR_Moneda)),2,'0'),VAR_Moneda)) ;
SET VAR_Npagos := trim(concat('10', LPAD(character_length(TRIM(VAR_NPagos)),2,'0'),VAR_NPagos)) ;
SET VAR_FrecPagos := trim(concat('11', LPAD(character_length(TRIM(VAR_FrecPagos)),2,'0'),VAR_FrecPagos)) ;
SET VAR_ImportePagos := trim(concat('12', LPAD(character_length(TRIM(VAR_ImportePagos)),2,'0'),VAR_ImportePagos)) ;
SET VAR_FechaInicio := trim(concat('13', LPAD(character_length(TRIM(VAR_FechaInicio)),2,'0'),VAR_FechaInicio)) ;
SET VAR_UltimoPago:=trim(concat('14', LPAD(character_length(TRIM(VAR_UltimoPago)),2,'0'),VAR_UltimoPago)) ;
SET VAR_FechaCompra := trim(concat('15', LPAD(character_length(TRIM(VAR_FechaInicio)),2,'0'),VAR_FechaInicio)) ;
SET VAR_FechaCierre:=trim(concat('16', LPAD(character_length(TRIM(VAR_FechaCierre)),2,'0'),VAR_FechaCierre));
SET VAR_FechaCierre=coalesce(VAR_FechaCierre,'');
SET VAR_FechaReporte := trim(concat('17', LPAD(character_length(TRIM(date_format(FechaCorteBC,'%d%m%Y'))),2,'0'),date_format(FechaCorteBC,'%d%m%Y'))) ;
SET VAR_MontoCredito := trim(concat('21', LPAD(character_length(TRIM(VAR_MontoCredito)),2,'0'),VAR_MontoCredito)) ;
SET VAR_saldo := trim(concat('22', LPAD(character_length(TRIM(VAR_saldo)),2,'0'),VAR_saldo)) ;
SET VAR_LimiteCred := trim(concat('23', LPAD(character_length(TRIM(VAR_MontoCredito)),2,'0'),VAR_MontoCredito)) ;
SET VAR_vencido := trim(concat('24', LPAD(character_length(TRIM(VAR_vencido)),2,'0'),VAR_vencido)) ;
SET VAR_NPagosVencidos := trim(concat('25', LPAD(character_length(TRIM(VAR_NPagosVencidos)),2,'0'),VAR_NPagosVencidos)) ;
SET VAR_MOP := trim(concat('26', LPAD(character_length(TRIM(VAR_MOP)),2,'0'),VAR_MOP)) ;


SET VAR_Incumplimiento := trim(concat('43', LPAD(character_length(TRIM(VAR_Incumplimiento)),2,'0'),VAR_Incumplimiento)) ;

SET CINTA:= concat(VAR_ApellidoPaterno,VAR_ApellidoMaterno,VAR_PrimerNombre,VAR_Segundo,VAR_FechaNacimiento,VAR_RFC,VAR_EstadoCivil,VAR_Sexo,VAR_CalleNumero,VAR_Colonia,VAR_Municipio,VAR_estado,VAR_CP,VAR_member,VAR_nombre,VAR_Cuenta,VAR_Responsabilidad,VAR_TipoCuenta,VAR_TipoContrato,VAR_Moneda,VAR_NPagos,VAR_FrecPagos,VAR_ImportePagos,VAR_FechaInicio,VAR_UltimoPago, VAR_FechaCompra,VAR_FechaCierre, date_format(FechaCorteBC,'%d%m%Y'),VAR_MontoCredito, VAR_saldo,VAR_NPagosVencidos,VAR_MOP,VAR_Incumplimiento,'9903FIN');

insert into BUROCREDINTF values ('',VAR_ClienteID,`Member`,FechaCorteBC,CINTA);

FETCH CUR1 INTO  VAR_ClienteID ,VAR_ApellidoPaterno ,VAR_ApellidoMaterno,VAR_Adicional,VAR_PrimerNombre,VAR_Segundo,VAR_FechaNacimiento,VAR_RFC,VAR_Prefijo,VAR_EstadoCivil,VAR_Sexo,VAR_FDef,VAR_InDef,VAR_CalleNumero,VAR_Colonia,VAR_Municipio,	VAR_estado,VAR_CP,VAR_Telefono,VAR_member,	VAR_nombre,VAR_Cuenta,VAR_Responsabilidad,VAR_TipoCuenta,	VAR_TipoContrato,	VAR_Moneda,	VAR_NPagos,VAR_FrecPagos,	VAR_saldo,	VAR_vencido,VAR_FechaInicio,VAR_MontoCredito,VAR_ImportePagos,VAR_Incumplimiento,VAR_FechaCierre,VAR_NPagosVencidos,VAR_NDiasAtraso,VAR_UltimoPago,VAR_MOP;


end while;

SET CINTA=RPAD(concat('TRLR',LPAD(VAR_SVigente,14,'0'),LPAD(VAR_SVencido,14,'0'),'001',LPAD(VAR_NSegmentos,9,'0'),LPAD(VAR_NSegmentos,9,'0'),'000000000',LPAD(VAR_NSegmentos,9,'0'),'000000',LPAD(NombreEmp,16,'0')),253,'0');
insert into BUROCREDINTF (ClienteID,Clave,Fecha,Cinta)values (0,`Member`,FechaCorteBC,CINTA);



 close CUR1;


  return   coalesce(CINTA,0);

END$$