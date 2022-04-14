-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBBLOQDESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBBLOQDESREP`;DELIMITER $$

CREATE PROCEDURE `TARDEBBLOQDESREP`(
   Par_FechaInicio       date,
   Par_FechaFin          date,
   Par_Mostrar           int(11),
   Par_ClienteID        int(11),
 	Par_TipoTarjetaDebID int(11),
   Par_CuentaAho        bigint(12),
  	Par_Motivo           int(11),


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
DECLARE Sald_Bloqueda			char(1);
DECLARE Sald_Inactiva			char(1);
DECLARE Sald_Registrada		char(1);
DECLARE Var_PerFisica 	char(1);
DECLARE Est_Activo         int;
DECLARE Est_Bloqueo        int;



Set Cadena_Vacia	       := '';
Set Fecha_Vacia		       := '1900-01-01';
Set Entero_Cero		       := 0;
Set Sald_Bloqueda		    := 'B';
Set Sald_Inactiva		    := 'I';
Set Sald_Registrada		 := 'R';
set Var_PerFisica       	:='F';
Set Est_Activo            :='7';
Set Est_Bloqueo           :='8';



    set Var_Sentencia :=  ' select Bit.TarjetaDebID,date(Bit.Fecha) as Fecha,UPPER(Eve.Descripcion) as TipoEventos ,UPPER(Cat.Descripcion) as Catalogo,UPPER(DescripAdicio) as DescripAdicio ';
    set Var_Sentencia :=  CONCAT(Var_Sentencia,'from BITACORATARDEB as Bit left join CATALCANBLOQTAR as Cat on Cat.MotCanBloID=Bit.MotivoBloqID left join TARDEBEVENTOSTD as Eve on Eve.TipoEvenTDID=Bit.TipoEvenTDID');
    set Var_Sentencia :=  CONCAT(Var_Sentencia,' left join TARJETADEBITO as Tar on Tar.TarjetaDebID=Bit.TarjetaDebID left join CLIENTES as Cli on Cli.ClienteID=Tar.ClienteID');
    set Var_Sentencia := 	CONCAT(Var_Sentencia,' left Join CUENTASAHO AS Cta on Cta.CuentaAhoID=Tar.CuentaAhoID  left join TIPOTARJETADEB as Tip on Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID WHERE ');

    set Var_Sentencia :=  CONCAT(Var_Sentencia,' (Date(Bit.Fecha) >= Date(?) and Date(Bit.Fecha) <= Date(?)) ');


    set Par_ClienteID := ifnull(Par_ClienteID, Entero_Cero);
    if(Par_ClienteID != Entero_Cero)then
        set Var_Sentencia = CONCAT(Var_sentencia,' and Cli.ClienteID =', convert(Par_ClienteID,char));
    end if;
 set Par_Motivo	 := ifnull(Par_Motivo,Entero_Cero);
        if(Par_Motivo	!=  Entero_Cero)then
            set Var_Sentencia = CONCAT(Var_sentencia,' and Bit.MotivoBloqID =',convert(Par_Motivo,char));
   end if;
    set Par_CuentaAho := ifnull(Par_CuentaAho ,Entero_Cero);
    if(Par_CuentaAho != Entero_Cero)then
        set Var_Sentencia = CONCAT(Var_sentencia,' and Tar.CuentaAhoID =',convert( Par_CuentaAho,char));
    end if;

    if (Par_Mostrar = Entero_Cero ) then
        set Var_Sentencia := CONCAT(Var_sentencia,' and (Bit.TipoEvenTDID = "8" or Bit.TipoEvenTDID = "7")');
    else if(Par_Mostrar = Est_Activo) then
            set Var_Sentencia := CONCAT(Var_sentencia,' and Bit.TipoEvenTDID =',convert(Par_Mostrar,char));
        else if (Par_Mostrar = Est_Bloqueo) then
            set Var_Sentencia := CONCAT(Var_sentencia,' and Bit.TipoEvenTDID =',convert(Par_Mostrar,char));
            end if;
        end if;
    end if;
    set Par_TipoTarjetaDebID := ifnull(Par_TipoTarjetaDebID ,Entero_Cero);
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