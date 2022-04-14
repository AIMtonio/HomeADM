-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBTIPOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBTIPOREP`;DELIMITER $$

CREATE PROCEDURE `TARJETADEBTIPOREP`(
    Par_FechaInicio       date,
    Par_FechaFin          date,
    Par_TipoTarjetaDebID int(11),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN


DECLARE Var_Sentencia 		varchar(4000);


DECLARE Cadena_Vacia		char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE FechaSist			date;


Set Cadena_Vacia	       := '';
Set Fecha_Vacia		       := '1900-01-01';
Set Entero_Cero		       := 0;

    set Var_Sentencia :=  ' select TarjetaDebID,Est.Descripcion as Estatus, LPAD(convert(Tar.CuentaAhoID, CHAR),10,0) as CuentaAhoID,NombreCompleto,Tipo.Descripcion as TipoTarjeta,Etiqueta ';
    set Var_Sentencia :=  CONCAT(Var_Sentencia,'from TARJETADEBITO as Tar left join ESTATUSTD as Est on Tar.Estatus=Est.EstatusID left join CLIENTES as Cli on Cli.ClienteID=Tar.ClienteID left join TIPOTARJETADEB as Tipo');
    set Var_Sentencia :=  CONCAT(Var_Sentencia,' on Tipo.TipoTarjetaDebID=Tar.TipoTarjetaDebID left join CUENTASAHO as Cta on Cta.CuentaAhoID=Tar.CuentaAhoID WHERE ');
    set Var_Sentencia :=  CONCAT(Var_Sentencia,' Tar.FechaRegistro >= ? and Tar.FechaRegistro <= ? ');

    set Par_TipoTarjetaDebID := ifnull(Par_TipoTarjetaDebID, Entero_Cero);
    if(Par_TipoTarjetaDebID != Entero_Cero)then
        set Var_Sentencia = CONCAT(Var_sentencia,' and Tar.TipoTarjetaDebID =',convert( Par_TipoTarjetaDebID,char));
    end if;


	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

   PREPARE STSESTATUSREP FROM @Sentencia;
      EXECUTE STSESTATUSREP USING @FechaInicio, @FechaFin;
      DEALLOCATE PREPARE STSESTATUSREP;




END TerminaStore$$