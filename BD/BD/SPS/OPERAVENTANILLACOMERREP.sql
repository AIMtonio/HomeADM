-- SP OPERAVENTANILLACOMERREP
DELIMITER ;

DROP PROCEDURE IF EXISTS OPERAVENTANILLACOMERREP;

DELIMITER $$
CREATE PROCEDURE `OPERAVENTANILLACOMERREP`(
  Par_FechaIni      date,
  Par_FechaFin      date,
  Par_Sucursal      int,
  Par_Caja          int,
  Par_Naturaleza    int,

  Par_EmpresaID   int,
  Aud_Usuario     int,
  Aud_FechaActual   DateTime,
  Aud_DireccionIP   varchar(15),
  Aud_ProgramaID    varchar(50),
  Aud_Sucursal    int,
  Aud_NumTransaccion  bigint
    )
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Sentencia     varchar(15000);
DECLARE Var_SentenciaTabla  varchar(500);
DECLARE Var_FechaSis    date;
DECLARE Var_SumaNatA    decimal(14,2);
DECLARE Var_SumaNatC    decimal(14,2);
DECLARE Var_Consecutivo   int(11);
DECLARE Var_FechaHabilAnt date;
DECLARE Var_SaldoInicialSuc decimal(14,2);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE Decimal_Cero    decimal;
DECLARE OrigenSI      char(1);
DECLARE OrigenNO      char(1);
DECLARE EfectivoSI      char(1);
DECLARE EfectivoNO      char(1);
DECLARE EntradaCambioID   int;
DECLARE SalidaCambioID    int;
DECLARE InstruCuenta    int;
DECLARE InstruCliente   int;
DECLARE InstruChequeSBC   int;
DECLARE InstruCredito   int;
DECLARE InstruNumeroTar   int;
DECLARE InstruCuentaBanc  int;
DECLARE InstruRemesa    int;
DECLARE InstruOportunid   int;
DECLARE InstruPagoServ    int;
DECLARE InstruDevGastAn   int;
DECLARE OperacionVent   int;
-- ID de Tipo Instrumento de Pago de Servicios en linea
DECLARE InstruPagoServLinea INT;
DECLARE GrupalSI      char(1);

DECLARE Tipo_PagoComCredito int;
DECLARE Tipo_CarteraCastiRe int;
DECLARE Tipo_GarantiaLiq  int;
DECLARE Tipo_DesembolsoCred int;
DECLARE Tipo_PagoCredito  int;
DECLARE Tipo_ReversaGarLiq  int;
DECLARE Tipo_RevPagComCred  int;
DECLARE Tipo_RevDesemCred int;
DECLARE Tipo_CobCobertRiesg int;
DECLARE Tipo_ApCobertRiesgo int;
DECLARE Tipo_RevApCobRiesgo int;
DECLARE Tipo_PrepagoCred  int;
DECLARE Tipo_SalEfectGL   int;
DECLARE Tipo_DepGarantiaLiq int;
DECLARE NaturalezaEntrada int;
DECLARE NaturalezaSalida  int;


-- Asignacion de Constantes
set Cadena_Vacia  := '';
set Fecha_Vacia   := '1900-01-01';
set Entero_Cero   := 0;
set Decimal_Cero    := 0.00;
set OrigenSI    := 'S'; -- Si es Origen
set OrigenNO    := 'N'; -- No es Origen
set EfectivoSI    := 'S'; -- Si es Efectivo
set EfectivoNO    := 'N'; -- No es Efectivo
set EntradaCambioID := 6;   -- ID para el Tipo de Operacion Entrada de Cambio
set SalidaCambioID  := 26;  -- ID para el Tipo de Operacion Salida de Cambio

set InstruCuenta  := 2; -- El tipo de Instrumento es de CUENTASAHO
set InstruCliente := 4; -- Tipo de Instrumento CLIENTES
set InstruChequeSBC := 9; -- Tipo de Instrumento COBROCHEQUESBC
set InstruCredito := 11; -- Tipo de Instrumento CREDITOS
set InstruDevGastAn := 12; -- Tipo de Instrumento DEVOLUCION DE GASTOS Y ANTICIPOS
set InstruNumeroTar := 14; -- Tipo de instrumento Numero de Tarjetas TARJETADEBITO
set InstruCuentaBanc:= 19; -- Tipo de Instrumento Cuentas Bancarias COBROCHEQUESBC
set InstruRemesa  := 22; -- Tipo de Instrumento REMESAS
set InstruOportunid := 23; -- Tipo de Instrumentos OPORTUNIDADES
Set InstruPagoServ  := 8;  -- Tipo de Instrumentos PAGO DE SERVICIOS
set OperacionVent := 15; -- Tipo de Operacion es de Ventanilla
-- ID de Tipo Instrumento de Pago de Servicios en linea
Set InstruPagoServLinea  := 30;
set GrupalSI    :='S'; -- Constante para validar si es grupal el tipo de Credito

Set Tipo_PagoComCredito := 23; -- Tipo de Pago Operacion Comision Pago de Credito
Set Tipo_GarantiaLiq  := 22; -- Tipo de Operacion Garantia liquida
Set Tipo_DesembolsoCred := 10; -- Tipo de Operacion Desembolso de Credito
Set Tipo_PagoCredito  := 28; -- Tipo de Operacion Pago de Credito
Set Tipo_ReversaGarLiq  := 49; -- Tipo de Operacion Reversa de Garantia Liquida
Set Tipo_RevPagComCred  := 57; -- Tipo de Operacion Reversa Pago Comision de Credito
Set Tipo_RevDesemCred := 56; -- Tipo de Operacion Reversa Desembolso de Credito
Set Tipo_CobCobertRiesg := 38; -- Tipo de Operacion Cobro Cobertura de Riesgo
Set Tipo_ApCobertRiesgo := 17; -- Tipo de Operacion Apertura Cobertura de Riesgo
Set Tipo_RevApCobRiesgo := 54; -- Tipo de Operacion Reversa Apertura Cobro de Riesgo
Set Tipo_PrepagoCred  := 79; -- Tipo de Operacion Prepago Credito
Set Tipo_SalEfectGL   := 35; -- tipo de Operacion Salida Efectivo Garantia Liquida
Set Tipo_CarteraCastiRe := 88; -- Tipo de Operacion Recuperacion Cartera Castigada
Set Tipo_DepGarantiaLiq := 44; -- Tipo de Operacion Deposito Garantia Liquida

Set NaturalezaEntrada   := 1; -- ID de la Naturaleza de Entrada
Set NaturalezaSalida  := 2; -- ID de la Naturaleza de Salida


-- Asignacion de Variables
Set Var_Sentencia     := '';
Set Var_SentenciaTabla  :='';
Set Var_SumaNatA    := 0.00;
Set Var_SumaNatC    := 0.00;
Set @Var_Consecutivo    :=0;




set Par_FechaIni:=ifnull(Par_FechaIni,'1900-01-01');
set Par_FechaFin:=ifnull(Par_FechaFin,'1900-01-01');
set Par_Sucursal:=ifnull(Par_Sucursal,0);
set Par_Caja:=ifnull(Par_Caja,0);
set Par_Naturaleza:=ifnull(Par_Naturaleza,0);




-- Tabla Temporal para almacenar los registros filtrados de CAJASMOVS
DROP TABLE IF EXISTS TMPOPERAVENTANILLACOMER;
  create temporary table TMPOPERAVENTANILLACOMER(
    Consecutivo int(11),
    Transaccion bigint(20) ,    	CajaID int(11),         DescripcionCaja char(150),
    ConsecutivoCaja int,      		Fecha date,           MontoEnFirme decimal(14,4),
    TipoOperacion int,        		Instrumento bigint(20),       Sucursal int,
    NombreSucurs char(70),      	Referencia varchar(200),    Descripcion varchar(200),
    Naturaleza int,         		EsEfectivo  char(1),      Origen char(1),
    DiferenciaMontos decimal(14,2), PolizaID bigint(20),      InstrumentoPol  varchar(20),
    TipoInstrumentoID int,    		MontoCambio decimal(14,2),    MontoDeposito decimal(14,2),
    MontoOperacion decimal(14,2), 	ClienteID int(11),        NombreCompleto varchar(200),
    GrupoID int,          			NombreGrupo char(100),
    PRIMARY KEY (`Consecutivo`, `Transaccion`)
  );
create index IDX_VENTANILLAREP on TMPOPERAVENTANILLACOMER(TipoOperacion, ConsecutivoCaja);
create index IDX_VENTANILLAREP_1 on TMPOPERAVENTANILLACOMER(Fecha);


DROP TABLE IF EXISTS TMPMONTOINICIAL;
 create temporary table TMPMONTOINICIAL(
    MontoInicial decimal(14,2)
);

Set Var_FechaSis=(Select FechaSistema from PARAMETROSSIS);

-- CAMBIO GHERNANDEZ
 CALL DIASHABILANTERCAL(Par_FechaIni,1,Var_FechaHabilAnt,1,1,now(),'','',0,0);

Set Var_SentenciaTabla := '
INSERT INTO TMPOPERAVENTANILLACOMER(
  Consecutivo,
  Transaccion,
  CajaID,
  DescripcionCaja,
  ConsecutivoCaja,
  Fecha,
  MontoEnFirme,
  TipoOperacion,
  Instrumento,
  Referencia,
  Sucursal,
  NombreSucurs,
  Descripcion,
  Naturaleza,
  EsEfectivo,
  Origen
)';

set Var_Sentencia := CONCAT(Var_SentenciaTabla,' Select  (select  (@Var_Consecutivo:= @Var_Consecutivo+1)) ,
    CM.Transaccion ,   CM.CajaID, CV.DescripcionCaja, CM.Consecutivo,
    CM.Fecha,  CM.MontoEnFirme, CM.TipoOperacion, CM.Instrumento,
    CM.Referencia,   CM.SucursalID, SUC.NombreSucurs,
    CTO.Descripcion,  CTO.Naturaleza,   CTO.EsEfectivo,   CTO.Origen
      from CAJASMOVS CM
        inner join CAJATIPOSOPERA CTO on CTO.Numero=CM.TipoOperacion
        inner join SUCURSALES SUC on CM.SucursalID=SUC.SucursalID
        inner join CAJASVENTANILLA CV on CM.SucursalID=CV.SucursalID and CM.CajaID=CV.CajaID
          where CM.Fecha>="',Par_FechaIni,'" and CM.Fecha<="',Par_FechaFin,'" '
);


Set Par_Sucursal := ifnull(Par_Sucursal,Entero_Cero);
if(Par_Sucursal != Entero_Cero) then
  Set Var_Sentencia := CONCAT(Var_Sentencia,' and CM.SucursalID=',Par_Sucursal);
end if;

Set Par_Caja := ifnull(Par_Caja,Entero_Cero);
if(Par_Caja != Entero_Cero) then
  Set Var_Sentencia := CONCAT(Var_Sentencia,' and CM.CajaID=',Par_Caja);
end if;


SET @Sentencia2 = (Var_Sentencia);  
  PREPARE OPERACIONESVENT2 FROM @Sentencia2;
  EXECUTE OPERACIONESVENT2;
  DEALLOCATE PREPARE OPERACIONESVENT2;

Set Var_Sentencia := '';
-- Insercion de todos los registros filtrados de `HIS-CAJASMOVS`
set Var_Sentencia := CONCAT(Var_SentenciaTabla,' Select  (select  (@Var_Consecutivo:= @Var_Consecutivo+1)),
    CM.Transaccion,  CM.CajaID, CV.DescripcionCaja, CM.Consecutivo,
    CM.Fecha,  CM.MontoEnFirme, CM.TipoOperacion, CM.Instrumento,
    CM.Referencia,   CM.SucursalID, SUC.NombreSucurs,
    CTO.Descripcion,  CTO.Naturaleza,   CTO.EsEfectivo,   CTO.Origen
      from `HIS-CAJASMOVS` CM
        inner join CAJATIPOSOPERA CTO on CTO.Numero=CM.TipoOperacion
        inner join SUCURSALES SUC on CM.SucursalID=SUC.SucursalID
        inner join CAJASVENTANILLA CV on CM.SucursalID=CV.SucursalID and CM.CajaID=CV.CajaID
          where CM.Fecha>="',Par_FechaIni,'" and CM.Fecha<="',Par_FechaFin,'" '
);

Set Par_Sucursal := ifnull(Par_Sucursal,Entero_Cero);
if(Par_Sucursal != Entero_Cero) then
  Set Var_Sentencia := CONCAT(Var_Sentencia,' and CM.SucursalID=',Par_Sucursal);
end if;

Set Par_Caja := ifnull(Par_Caja,Entero_Cero);
if(Par_Caja != Entero_Cero) then

  Set Var_Sentencia := CONCAT(Var_Sentencia,' and CM.CajaID=',Par_Caja);
end if;

SET @Sentencia2 = (Var_Sentencia);

  PREPARE OPERACIONESVENT2 FROM @Sentencia2;
  EXECUTE OPERACIONESVENT2;
  DEALLOCATE PREPARE OPERACIONESVENT2;
  
Set Var_SentenciaTabla := 'INSERT INTO TMPMONTOINICIAL(MontoInicial)';
Set Var_Sentencia := '';
Set Var_Sentencia := CONCAT(Var_SentenciaTabla, ' Select ifnull(sum(case DenominacionID
                          when 1 then Cantidad*1000
                          when 2 then Cantidad*500
                          when 3 then Cantidad*200
                          when 4 then Cantidad*100
                          when 5 then Cantidad*50
                          when 6 then Cantidad*20
                          when 7 then Cantidad*1 end),0.0)
                    from `HIS-BALANZADENO`
                    where  SucursalID=', Par_Sucursal );

Set Par_Caja := ifnull(Par_Caja,Entero_Cero);
if(Par_Caja != Entero_Cero) then
  Set Var_Sentencia := CONCAT(Var_Sentencia,' and CajaID=',Par_Caja);
end if;
Set Var_Sentencia := CONCAT(Var_Sentencia,' and Fecha="',Var_FechaHabilAnt,'";');

SET @Sentencia2 = (Var_Sentencia);

  PREPARE OPERACIONESVENT2 FROM @Sentencia2;
  EXECUTE OPERACIONESVENT2;
  DEALLOCATE PREPARE OPERACIONESVENT2;


-- Tabla temporal para almacenar los Montos En Firme de cada Transaccion
DROP TABLE IF EXISTS TMPMONTOS;
  create temporary table TMPMONTOS(
    Consecutivo int(11),      Transaccion bigint(20),     MontoOperacion decimal(14,2),
    MontoDeposito decimal(14,2),  MontoCambio decimal(14,2),    TipoOperacion   int,
    PRIMARY KEY (`Consecutivo`, `Transaccion`)
  );
create index IDXMONTOS on TMPMONTOS(TipoOperacion);

update TMPOPERAVENTANILLACOMER set Origen = OrigenSI where TipoOperacion = 60;

INSERT INTO TMPMONTOS (
Consecutivo, Transaccion, MontoOperacion, MontoDeposito, MontoCambio, TipoOperacion
)select Consecutivo, Transaccion,Decimal_Cero,Decimal_Cero,Decimal_Cero, TipoOperacion
      from TMPOPERAVENTANILLACOMER where Origen=OrigenSI;

-- Se inserta el Monto en Firme en Monto Operacion cuando sea la Operacion Principal
update TMPMONTOS TMPM, TMPOPERAVENTANILLACOMER TMPO set TMPM.MontoOperacion = TMPO.MontoEnFirme
    where TMPO.Origen= OrigenSI
        and TMPM.Transaccion=TMPO.Transaccion
        and TMPM.TipoOperacion = TMPO.TipoOperacion;

update TMPMONTOS TMPM, TMPOPERAVENTANILLACOMER TMPO set
      TMPM.MontoOperacion =TMPO.MontoEnFirme
      where  TMPM.Transaccion=TMPO.Transaccion
        and TMPM.TipoOperacion = TMPO.TipoOperacion
        and TMPM.Consecutivo =TMPO.Consecutivo;

update TMPOPERAVENTANILLACOMER set Origen =
                        CASE TipoOperacion when  59
                          then OrigenNO  when  60
                          then OrigenSI else Origen end;


-- Se inserta el Monto en Firme en Monto Deposito cuando NO sean Entradas o Salidas de Cambio
update TMPMONTOS TMPM, TMPOPERAVENTANILLACOMER TMPO
      set TMPM.MontoDeposito=TMPO.MontoEnFirme
          where TMPO.Origen=OrigenNO
          and TMPO.EsEfectivo=EfectivoSI
          and TMPO.TipoOperacion<>EntradaCambioID
          and TMPO.TipoOperacion<>SalidaCambioID
          and TMPM.Transaccion = TMPO.Transaccion
          and TMPO.Naturaleza = NaturalezaEntrada
          and CASE TMPO.TipoOperacion when 59 then  TMPM.Consecutivo=TMPO.Consecutivo
                        when 60 then TMPM.Consecutivo = TMPO.Consecutivo
                        else TMPO.TipoOperacion<>SalidaCambioID end;

update TMPOPERAVENTANILLACOMER set Origen =
                        CASE TipoOperacion when  60
                          then OrigenNO  when  59
                          then OrigenSI else Origen end;

-- Se inserta el Monto en Firme en Monto Cambio cuando SI sean Entradas o Salidas de Cambio
update TMPMONTOS TMPM, TMPOPERAVENTANILLACOMER TMPO
      set TMPM.MontoCambio    = TMPO.MontoEnFirme
          where TMPO.Origen   = OrigenNO
          and TMPO.EsEfectivo = EfectivoSI
          and (TMPO.TipoOperacion = EntradaCambioID
            or TMPO.TipoOperacion = SalidaCambioID
            or TMPO.TipoOperacion = 60)
          and TMPM.Transaccion = TMPO.Transaccion
          and case TMPO.TipoOperacion when 60 then TMPM.Consecutivo = TMPO.Consecutivo
                        else TMPM.Transaccion = TMPO.Transaccion end;

update TMPMONTOS TMPM, TMPOPERAVENTANILLACOMER TMPO
        set TMPM.Consecutivo = TMPO.Consecutivo
          where TMPO.Transaccion = TMPM.Transaccion
            and TMPM.Consecutivo = TMPO.Consecutivo;

update TMPOPERAVENTANILLACOMER set Origen = OrigenSI where TipoOperacion=59 or TipoOperacion = 60;

-- Limpieza de Registros -> Solo Operaciones Principales
delete from TMPOPERAVENTANILLACOMER where Origen = OrigenNO;

-- Debido a la Naturaleza del Origen de  la Operacion,
-- Cuando Se generen operaciones de Entrada Se Invertira el Valor a Salida y  Viceversa
Set Par_Naturaleza := ifnull(Par_Naturaleza,Entero_Cero);
if(Par_Naturaleza != Entero_Cero) then
  if(Par_Naturaleza = NaturalezaEntrada)then
    delete from TMPOPERAVENTANILLACOMER where Origen= OrigenSI and Naturaleza= NaturalezaEntrada ;
  end if;
  if(Par_Naturaleza = NaturalezaSalida)then
    delete from TMPOPERAVENTANILLACOMER where Origen= OrigenSI and Naturaleza= NaturalezaSalida;
  end if;
end if;

-- Tabla temporal para almacenar los detalles de la poliza
DROP TABLE IF EXISTS TMPDETALLEPOLIZA;
  create temporary table TMPDETALLEPOLIZA(
    Transaccion bigint(20),   PolizaID bigint,      Instrumento varchar(20),
    TipoInstrumentoID int,    Referencia  varchar(200), Consecutivo int,
    PRIMARY KEY (`Consecutivo`, `Transaccion`)
);
create index IDX_TMPDETALLEPOLIZA_1 on TMPDETALLEPOLIZA(PolizaID);

-- CS JCENTENO 11113
INSERT INTO TMPDETALLEPOLIZA(
Transaccion,
PolizaID,
Instrumento,
TipoInstrumentoID,
Referencia,
Consecutivo
)select DP.NumTransaccion,MAX(DP.PolizaID),MAX(TMPO.Instrumento),MIN(DP.TipoInstrumentoID), MAX(DP.Referencia), TMPO.Consecutivo 
    from DETALLEPOLIZA DP inner join TMPOPERAVENTANILLACOMER TMPO
        on TMPO.Transaccion = DP.NumTransaccion
          and TMPO.Fecha  = DP.Fecha
          group by DP.NumTransaccion,  TMPO.Consecutivo
          ORDER by DP.NumTransaccion;

INSERT INTO TMPDETALLEPOLIZA (
Transaccion,
PolizaID,
Instrumento,
TipoInstrumentoID,
Referencia,
Consecutivo
)select DP.NumTransaccion,MAX(DP.PolizaID),MAX(TMPO.Instrumento),MIN(TMPO.TipoInstrumentoID), MAX(DP.Referencia), TMPO.Consecutivo 
    from `HIS-DETALLEPOL` DP inner join TMPOPERAVENTANILLACOMER TMPO
        on DP.NumTransaccion = TMPO.Transaccion
          and TMPO.Fecha   = DP.Fecha
          group by DP.NumTransaccion, TMPO.Consecutivo
          ORDER by DP.NumTransaccion;
                    

-- Se actualiza los instrumentos cuando es garantia liquida por posibles Creditos Grupales
update TMPOPERAVENTANILLACOMER TMPO, TMPDETALLEPOLIZA DP set DP.Instrumento = TMPO.Instrumento
        where TMPO.Transaccion= DP.Transaccion and TMPO.Consecutivo= DP.Consecutivo
            and (TMPO.TipoOperacion=28 or TMPO.TipoOperacion = 44 );

-- Tabla para almacenar los clientes referentes a las Operaciones Hechas
DROP TABLE IF EXISTS TMPCLIENTES;
  create temporary table TMPCLIENTES(
    Transaccion bigint(20),    Consecutivo int, ClienteID int(11),
    NombreCompleto varchar(200), GrupoID int,   NombreGrupo char(100),
    PRIMARY KEY (`Consecutivo`, `Transaccion`)
);
create index IDX_TMPCLIENTES_1 on TMPCLIENTES(ClienteID);


INSERT INTO TMPCLIENTES(
Transaccion, Consecutivo, ClienteID
)select DP.Transaccion, DP.Consecutivo, CASE DP.TipoInstrumentoID
              when InstruCuenta then
              (select C.ClienteID
                  from CUENTASAHO CA
                    inner join CLIENTES C
                      on CA.ClienteID=C.ClienteID
                        where CA.CuentaAhoID=DP.Instrumento )
              when InstruCliente then
                    (select ClienteID from CLIENTES where ClienteID=DP.Instrumento)
              when InstruChequeSBC then
              (select ACS.ClienteID from ABONOCHEQUESBC ACS
                  inner join CLIENTES C on ACS.ClienteID=C.ClienteID
                    where ACS.NumCheque=DP.Instrumento and ACS.CuentaEmisor = DP.Referencia)
              when InstruCuentaBanc then
                (select ACS.ClienteID from ABONOCHEQUESBC ACS
                  inner join CLIENTES C on ACS.ClienteID=C.ClienteID
                    where ACS.NumCheque=DP.Instrumento and ACS.CuentaEmisor = DP.Referencia)
              when InstruCredito then
              (select C.ClienteID
                from CREDITOS CRED inner join CLIENTES C
                  on CRED.ClienteID=C.ClienteID where CreditoID=DP.Instrumento)
              when InstruNumeroTar then
              (select C.ClienteID from TARJETADEBITO TD inner join CLIENTES C
                  on TD.ClienteID = C.ClienteID where TarjetaDebID=DP.Instrumento)
              when InstruRemesa then
              (select ifnull(C.ClienteID,Entero_Cero) from PAGOREMESAS PR inner join CLIENTES C
                  on PR.ClienteID=C.ClienteID where PR.RemesaFolio=DP.Referencia )
              when InstruOportunid then
              (select C.ClienteID from  CLIENTES  C
                  inner join PAGOPORTUNIDADES PO  on PO.ClienteID=C.ClienteID and PO.ClienteID>Entero_Cero
                  where PO.Referencia = DP.Instrumento and DP.Instrumento<>'0' )
              when InstruPagoServ then
                (select C.ClienteID from CLIENTES C inner join PAGOSERVICIOS PS
                      on C.ClienteID = PS.ClienteID where PS.ClienteID>0
                        and PS.Referencia=DP.Referencia and PS.NumTransaccion=DP.Transaccion)
              when InstruPagoServLinea then
                (select PSLCOBROSL.ClienteID from PSLCOBROSL
                      where PSLCOBROSL.ClienteID > 0
                      and PSLCOBROSL.NumTransaccion = DP.Transaccion)
              else Entero_Cero end
            from TMPDETALLEPOLIZA DP;
    

-- Debido a que el instrumento de la poliza de SERVIFUN es su folio, se hace el siguiente query para sacar el cliente
update TMPCLIENTES TMPC, TMPOPERAVENTANILLACOMER TMPO, TMPDETALLEPOLIZA DP
      set TMPC.ClienteID = CASE WHEN TMPO.TipoOperacion = 91 then
            (select SE.ClienteID from CLIENTES C inner join SERVIFUNENTREGADO SE on C.ClienteID = SE.ClienteID
                       where SE.ServiFunFolioID=DP.Instrumento)
                else TMPC.ClienteID
                  end
        where TMPC.Transaccion= TMPO.Transaccion and TMPO.Transaccion=DP.Transaccion;

-- Validacion de Tipo de Operacion para encontrar el Grupo del crÃ©dito
update TMPCLIENTES TMPC, TMPOPERAVENTANILLACOMER TMPO
    set TMPC.GrupoID = CASE WHEN (TMPO.TipoOperacion = Tipo_PagoComCredito or
                     TMPO.TipoOperacion = Tipo_GarantiaLiq  or
                     TMPO.TipoOperacion = Tipo_DesembolsoCred or
                     TMPO.TipoOperacion = Tipo_PagoCredito    or
                     TMPO.TipoOperacion = Tipo_ReversaGarLiq  or

                     TMPO.TipoOperacion = Tipo_RevPagComCred  or
                     TMPO.TipoOperacion = Tipo_RevDesemCred or
                     TMPO.TipoOperacion = Tipo_CobCobertRiesg or
                     TMPO.TipoOperacion = Tipo_ApCobertRiesgo or
                     TMPO.TipoOperacion = Tipo_RevApCobRiesgo or
                     TMPO.TipoOperacion = Tipo_PrepagoCred    or
                     TMPO.TipoOperacion = Tipo_SalEfectGL) then
                    (select CRED.GrupoID from CREDITOS CRED where CRED.CreditoID=TMPO.Referencia)
        when TMPO.TipoOperacion = Tipo_CarteraCastiRe then
                (select CRED.GrupoID from CRECASTIGOSREC CCR  inner join CREDITOS CRED on CCR.CreditoID= CRED.CreditoID where CCR.NumTransaccion=TMPO.Transaccion)
        else ifnull(TMPC.GrupoID ,Entero_Cero)
          end
      where TMPC.Transaccion=TMPO.Transaccion;

-- Valores Nulos a 0 o " "
update TMPCLIENTES set ClienteID = ifnull(ClienteID,0), NombreCompleto = ifnull(NombreCompleto,'N/A'), NombreGrupo =ifnull(NombreGrupo,'N/A');
-- Consulta del Nombre del Grupo
update TMPCLIENTES TMC, GRUPOSCREDITO GC set TMC.NombreGrupo = ifnull(GC.NombreGrupo,'N/A') where TMC.GrupoID=GC.GrupoID;
-- Consulta del Nombre Completo del Cliente
update TMPCLIENTES TMC,CLIENTES C set TMC.NombreCompleto = C.NombreCompleto where TMC.ClienteID=C.ClienteID;

-- Se actualiza la Naturaleza de todas las operaciones debido a la naturaleza del Origen de la Operacion
update TMPOPERAVENTANILLACOMER TMP Set Naturaleza = CASE TMP.Naturaleza
                        when  NaturalezaEntrada
                          then NaturalezaSalida
                        when NaturalezaSalida
                          then NaturalezaEntrada
                        end;

update TMPOPERAVENTANILLACOMER set Naturaleza = CASE TipoOperacion
                        when 59
                          then NaturalezaEntrada
                        when 60
                          then NaturalezaSalida
                        else Naturaleza
                        end;

-- update TMPOPERAVENTANILLACOMER TMP Set TMP.MontoDeposito = Decimal_Cero where TMP.Naturaleza = NaturalezaSalida;

DROP TABLE IF EXISTS TMPDIFERENCIASMONTOS;
CREATE TEMPORARY TABLE TMPDIFERENCIASMONTOS(
  MontoPorTrans decimal(14,2) , Naturaleza int, Sucursal int, Transaccion bigint
);
create index IDX_DIFERENCIAS on TMPDIFERENCIASMONTOS (Transaccion);
create index IDX_DIFERENCIAS_1 on TMPDIFERENCIASMONTOS (Sucursal);

insert into TMPDIFERENCIASMONTOS(
  MontoPorTrans , Naturaleza , Sucursal,  Transaccion
)select TM.MontoOperacion, TMPO.Naturaleza,TMPO.Sucursal, TM.Transaccion
    from TMPMONTOS TM, TMPOPERAVENTANILLACOMER TMPO
            where TM.Transaccion=TMPO.Transaccion and TM.TipoOperacion= TMPO.TipoOperacion
                and TM.Consecutivo = TMPO.Consecutivo
          order by TMPO.Sucursal,TMPO.Naturaleza, TMPO.CajaID, TMPO.TipoOperacion, TMPO.Transaccion;

DROP TEMPORARY TABLE IF EXISTS TMPSUMAMONTOS;
CREATE TEMPORARY TABLE TMPSUMAMONTOS(
SumaPorSuc decimal(14,2), Naturaleza int,Sucursal int ,Transaccion bigint
);
create index IDXSUMAS on TMPSUMAMONTOS(Transaccion);
create index IDXSUMAS_1 on TMPSUMAMONTOS(Sucursal);

-- se suma los montos agrupados por sucursal y naturaleza para poder sacar la diferencia de entradas vs salidas
insert into TMPSUMAMONTOS(
SumaPorSuc, Naturaleza,Sucursal,Transaccion
)select sum(DIFM.MontoPorTrans), DIFM.Naturaleza, DIFM.Sucursal,MAX(DIFM.Transaccion)
  from TMPDIFERENCIASMONTOS DIFM group by DIFM.Sucursal,DIFM.Naturaleza;

-- Se saca la diferencia entradas vs salidas
update TMPOPERAVENTANILLACOMER TMP,
     TMPMONTOINICIAL Mon
    set TMP.DiferenciaMontos = (select sum(if(TMPS.Naturaleza = 1 ,TMPS.SumaPorSuc,0)
                  - if(TMPS.Naturaleza = 2,TMPS.SumaPorSuc,0))
                    from TMPSUMAMONTOS TMPS
                    where TMPS.Sucursal=TMP.Sucursal group by TMP.Sucursal)+Mon.MontoInicial;

-- Montos en 0.00 para cuando es una operacion Garantia Liquida
update TMPMONTOS TMPM set TMPM.MontoDeposito = Decimal_Cero,
              TMPM.MontoCambio   = Decimal_Cero where TMPM.TipoOperacion = Tipo_DepGarantiaLiq;

-- traspaso de informacion a la tabla principal para la consulta final
update TMPOPERAVENTANILLACOMER TMPO, TMPDETALLEPOLIZA TMPD
                set TMPO.InstrumentoPol = TMPD.Instrumento,
                  TMPO.TipoInstrumentoID = TMPD.TipoInstrumentoID,
                  TMPO.PolizaID      = TMPD.PolizaID
                  where TMPO.Transaccion = TMPD.Transaccion
                  and TMPO.Consecutivo   = TMPD.Consecutivo;

update TMPOPERAVENTANILLACOMER TMPO, TMPMONTOS TMPM
                set TMPO.MontoCambio= TMPM.MontoCambio,
                  TMPO.MontoDeposito = TMPM.MontoDeposito,
                  TMPO.MontoOperacion = TMPM.MontoOperacion
                where TMPO.Transaccion = TMPM.Transaccion
                and TMPO.TipoOperacion = TMPM.TipoOperacion
                and TMPO.Consecutivo = TMPM.Consecutivo;

update TMPOPERAVENTANILLACOMER TMPO, TMPCLIENTES TMPC
                set TMPO.ClienteID  =  TMPC.ClienteID,
                  TMPO.NombreCompleto = TMPC.NombreCompleto,
                  TMPO.GrupoID    = TMPC.GrupoID,
                  TMPO.NombreGrupo    = TMPC.NombreGrupo
                where TMPO.Transaccion = TMPC.Transaccion
                and TMPO.Consecutivo = TMPC.Consecutivo;

select TMPO.Transaccion as Transaccion,         TMPO.CajaID as CajaID,        TMPO.DescripcionCaja as DescripcionCaja,
     TMPO.Fecha as Fecha,               TMPO.MontoEnFirme as MontoEnFirme,  TMPO.TipoOperacion as TipoOperacion,
     TMPO.Sucursal as Sucursal,           TMPO.NombreSucurs as NombreSucurs,  TMPO.Descripcion,
     concat(TMPO.Referencia,'-',TMPO.Descripcion) as DescripcionRef,
     TMPO.Naturaleza as Naturaleza,           TMPO.PolizaID as PolizaID,      TMPO.InstrumentoPol as Instrumento,
     TMPO.TipoInstrumentoID as TipoInstrumentoID,   TMPO.MontoOperacion as MontoOperac, TMPO.MontoDeposito as MontoDeposito,
     TMPO.MontoCambio as MontoCambio,           ifnull(TMPO.ClienteID,'') as ClienteID,     TMPO.NombreCompleto as NombreCompleto,
     convert(concat(TMPO.GrupoID,'-',TMPO.NombreGrupo),char) as NombreGrupo, TMPO.DiferenciaMontos as DiferenciaMontos,Mon.MontoInicial
      from TMPOPERAVENTANILLACOMER TMPO ,
         TMPMONTOINICIAL Mon
          order by TMPO.Sucursal,TMPO.Naturaleza, TMPO.CajaID, TMPO.TipoOperacion, TMPO.Transaccion;
END TerminaStore$$