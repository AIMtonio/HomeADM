-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBMEMORY
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBMEMORY`;DELIMITER $$

CREATE PROCEDURE `TARDEBMEMORY`(
  Par_Transaccion     int(11),
    Par_NumTarjetaID    char(16)
	)
TerminaStore:BEGIN

DECLARE Inicia              int(11);
DECLARE Actualiza           int(11);
DECLARE Con_DispoDiario     int(11);
DECLARE Con_DispoMes        int(11);
DECLARE Con_CompraDiario    int(11);
DECLARE Con_CompraMes       int(11);
DECLARE Con_NumDispoDia     int(11);
DECLARE Con_NumConsultaMes	int(11);
DECLARE Con_BloqATM         int(11);
DECLARE Con_BloqPOS         int(11);
DECLARE Con_BloqCashB       int(11);
DECLARE Con_OpeMOTO         int(11);


DECLARE IdentSocio	        char(1);


Set Inicia      := 1;
Set Actualiza   := 2;

Set Con_DispoDiario     := 1;
Set Con_DispoMes        := 2;
Set Con_CompraDiario    := 3;
Set Con_CompraMes       := 4;

Set Con_NumDispoDia     := 1;
Set Con_NumConsultaMes	:= 3;
Set Con_BloqATM     := 1;
Set Con_BloqPOS     := 2;
Set Con_BloqCashB   := 3;
Set Con_OpeMOTO     := 4;
Set IdentSocio      := 'S';

if (Par_Transaccion = Inicia ) then
    if not exists(
            SELECT Table_Name
                FROM information_schema.tables where table_schema = 'microfin'
                    AND Table_Name like 'MEM_TARJETADEBITO') then

        CREATE TABLE MEM_TARJETADEBITO ENGINE = MEMORY
            SELECT
                tar.TarjetaDebID,   tar.FechaRegistro,      tar.FechaVencimiento,   tar.Estatus,        tar.ClienteID,
                tar.CuentaAhoID,    tar.TipoTarjetaDebID,   tip.CompraPOSLinea,     tar.NoDispoDiario,  tar.NoDispoMes,
                tar.MontoDispoDiario,tar.MontoDispoMes,    tar.NoConsultaSaldoMes, tar.NoCompraDiario, tar.NoCompraMes,
                tar.MontoCompraDiario,tar.MontoCompraMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario) as LimiteDispoDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoMes) as LimiteDispoMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario) as LimiteCompraDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes) as LimiteCompraMes,
                FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumDispoDia) as LimiteNoDispoDiario,
				FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumConsultaMes) as LimiteNoConsultaMes,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM) as BloqueoATM,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS) as BloqueoPOS,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqCashB) as BloqueoCashB,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_OpeMOTO) as OperaMOTO
            FROM TARJETADEBITO tar, TIPOTARJETADEB tip
            WHERE tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
				AND tip.IdentificacionSocio != IdentSocio;

        ALTER TABLE `MEM_TARJETADEBITO`
            ADD PRIMARY KEY (`TarjetaDebID`);
    else
        DROP TABLE MEM_TARJETADEBITO;
        CREATE TABLE MEM_TARJETADEBITO ENGINE = MEMORY
            SELECT
                tar.TarjetaDebID,   tar.FechaRegistro,      tar.FechaVencimiento,   tar.Estatus,        tar.ClienteID,
                tar.CuentaAhoID,    tar.TipoTarjetaDebID,   tip.CompraPOSLinea,     tar.NoDispoDiario,  tar.NoDispoMes,
                tar.MontoDispoDiario,tar.MontoDispoMes,    tar.NoConsultaSaldoMes, tar.NoCompraDiario, tar.NoCompraMes,
                tar.MontoCompraDiario,tar.MontoCompraMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario) as LimiteDispoDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoMes) as LimiteDispoMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario) as LimiteCompraDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes) as LimiteCompraMes,
                FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumDispoDia) as LimiteNoDispoDiario,
				FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumConsultaMes) as LimiteNoConsultaMes,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM) as BloqueoATM,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS) as BloqueoPOS,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqCashB) as BloqueoCashB,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_OpeMOTO) as OperaMOTO
             FROM TARJETADEBITO tar, TIPOTARJETADEB tip
            WHERE tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
				AND tip.IdentificacionSocio != IdentSocio;

        ALTER TABLE `MEM_TARJETADEBITO`
            ADD PRIMARY KEY (`TarjetaDebID`);
    end if;
end if;

if (Par_Transaccion = Actualiza ) then
    if exists(SELECT Table_Name
                FROM information_schema.tables where table_schema = 'microfin'
                    AND Table_Name like 'MEM_TARJETADEBITO') then

        UPDATE MEM_TARJETADEBITO mem, (
            SELECT
                tar.TarjetaDebID,   tar.FechaRegistro,      tar.FechaVencimiento,   tar.Estatus,    tar.ClienteID,
                tar.CuentaAhoID,    tar.TipoTarjetaDebID,   tip.CompraPOSLinea, tar.NoDispoDiario, tar.NoDispoMes,
                tar.MontoDispoDiario, tar.MontoDispoMes, tar.NoConsultaSaldoMes, tar.NoCompraDiario, tar.NoCompraMes,
                tar.MontoCompraDiario, tar.MontoCompraMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario) as LimiteDispoDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoMes) as LimiteDispoMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario) as LimiteCompraDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes) as LimiteCompraMes,
                FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumDispoDia) as LimiteNoDispoDiario,
				FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumConsultaMes) as LimiteNoConsultaMes,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM) as BloqueoATM,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS) as BloqueoPOS,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqCashB) as BloqueoCashB,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_OpeMOTO) as OperaMOTO
			FROM TARJETADEBITO tar, TIPOTARJETADEB tip
            WHERE tar.TarjetaDebID = Par_NumTarjetaID and tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
				AND tip.IdentificacionSocio != IdentSocio) tardeb
        SET
            mem.FechaRegistro       = tardeb.FechaRegistro,
            mem.FechaVencimiento    = tardeb.FechaVencimiento,
            mem.Estatus             = tardeb.Estatus,
            mem.ClienteID           = tardeb.ClienteID,
            mem.CuentaAhoID         = tardeb.CuentaAhoID,
            mem.TipoTarjetaDebID    = tardeb.TipoTarjetaDebID,
            mem.CompraPOSLinea      = tardeb.CompraPOSLinea,
            mem.NoDispoDiario       = tardeb.NoDispoDiario,
            mem.NoDispoMes          = tardeb.NoDispoMes,
            mem.MontoDispoDiario    = tardeb.MontoDispoDiario,
            mem.MontoDispoMes       = tardeb.MontoDispoMes,
            mem.NoConsultaSaldoMes  = tardeb.NoConsultaSaldoMes,
            mem.NoCompraDiario      = tardeb.NoCompraDiario,
            mem.NoCompraMes         = tardeb.NoCompraMes,
            mem.MontoCompraDiario   = tardeb.MontoCompraDiario,
            mem.MontoCompraMes      = tardeb.MontoCompraMes,
            mem.LimiteDispoDiario   = tardeb.LimiteDispoDiario,
            mem.LimiteDispoMes      = tardeb.LimiteDispoMes,
            mem.LimiteCompraDiario  = tardeb.LimiteCompraDiario,
            mem.LimiteCompraMes     = tardeb.LimiteCompraMes,
            mem.LimiteNoDispoDiario = tardeb.LimiteNoDispoDiario,
			mem.LimiteNoConsultaMes	= tardeb.LimiteNoConsultaMes,
            mem.BloqueoATM          = tardeb.BloqueoATM,
            mem.BloqueoPOS          = tardeb.BloqueoPOS,
            mem.BloqueoCashB        = tardeb.BloqueoCashB,
            mem.OperaMOTO           = tardeb.OperaMOTO
        WHERE mem.TarjetaDebID  = Par_NumTarjetaID;

    else

        CREATE TABLE MEM_TARJETADEBITO ENGINE = MEMORY
            SELECT
                tar.TarjetaDebID,   tar.FechaRegistro,      tar.FechaVencimiento,   tar.Estatus,    tar.ClienteID,
                tar.CuentaAhoID,    tar.TipoTarjetaDebID,   tip.CompraPOSLinea, tar.NoDispoDiario, tar.NoDispoMes,
                tar.MontoDispoDiario, tar.MontoDispoMes, tar.NoConsultaSaldoMes, tar.NoCompraDiario, tar.NoCompraMes,
                tar.MontoCompraDiario, tar.MontoCompraMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoDiario) as LimiteDispoDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_DispoMes) as LimiteDispoMes,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraDiario) as LimiteCompraDiario,
                FUNCIONLIMITEMONTO(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_CompraMes) as LimiteCompraMes,
                FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumDispoDia) as LimiteNoDispoDiario,
				FUNCIONLIMITENUM(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_NumConsultaMes) as LimiteNoConsultaMes,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqATM) as BloqueoATM,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqPOS) as BloqueoPOS,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_BloqCashB) as BloqueoCashB,
                FUNCIONLIMITEBLOQ(tar.TarjetaDebID,   tar.ClienteID,  tar.TipoTarjetaDebID, Con_OpeMOTO) as OperaMOTO
            FROM TARJETADEBITO tar, TIPOTARJETADEB tip
            WHERE tar.TipoTarjetaDebID = tip.TipoTarjetaDebID
				AND tip.IdentificacionSocio != IdentSocio;

        ALTER TABLE `MEM_TARJETADEBITO`
            ADD PRIMARY KEY (`TarjetaDebID`);
    end if;
end if;
END TerminaStore$$