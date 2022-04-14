-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPORGRUPOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPORGRUPOPRO`;DELIMITER $$

CREATE PROCEDURE `AVALESPORGRUPOPRO`(
    Par_GrupoID         int(11),
    Par_SoliciCredID    bigint(20),
    Par_NumIntegra      int(11),
    Par_ProducCreID     int(11),
    Par_ReqAvales       char(1),        -- (S/N) Si el Producto de Credito Requiere Avales Adicional
                                        -- A los Integrantes del Grupo

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Aud_EmpresaID       int(11),
    Aud_Usuario         int(11),
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int(11),
    Aud_NumTransaccion  bigint(20)
		)
TerminaStore: BEGIN

-- Declaracion de Variables
declare Var_GrupoID     int(11);
declare Var_SolCredID   bigint(20);
declare Var_ClienteID   int(11);
declare Var_ProspectoID int(11);

declare Var_CteAsigna       int(11);
declare Var_ProspeAsigna    int(11);
declare Var_TotAsiAvales    int(11);

-- Declaracion de Constantes
declare Entero_Cero     int;
declare Cadena_Vacia    char(1);
declare Fecha_Vacia     date;
declare SalidaSI        char(1);
declare SalidaNO        char(1);
declare Sol_Activa      char(1);
declare Req_AvalesSI    char(1);
declare Req_AvalesNO    char(1);
declare Aval_Autori     char(1);
DECLARE Var_RelOtParen	INT(11);		-- Constante para la relacion OTRO PARENTESCO
DECLARE Var_DecCeroUno	DECIMAL(14,2);	-- Decimal 0.1

DECLARE  CURSORGRABAVALES  CURSOR FOR
    SELECT Ing.GrupoID, Ing.SolicitudCreditoID, Sol.ClienteID,  Sol.ProspectoID
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol
        WHERE Ing.GrupoID               = Par_GrupoID
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          and Sol.SolicitudCreditoID    <> Par_SoliciCredID
          AND Sol.Estatus               = Sol_Activa;


-- Asignacion de Constantes
Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set SalidaSI        := 'S';             -- Salida del Store: SI
Set SalidaNO        := 'N';             -- Salida del Store: NO
Set Sol_Activa      := 'A';             -- Estatus de la Solicitud de Credito: Activa
Set Req_AvalesSI    := 'S';             -- El producto de Credito SI Requiere Avales Adicionales
Set Req_AvalesNO    := 'N';             -- El producto de Credito NO Requiere Avales Adicionales
Set Aval_Autori     := 'U';             -- Estatus de la Asignacion del Aval: Autorizado
SET Var_RelOtParen	:= 45;				-- Constante para la relacion OTRO PARENTESCO
SET Var_DecCeroUno	:= 0.1;				-- Decimal 0.1

-- Inicializacion
set Par_NumErr  := Entero_Cero;
set Par_ErrMen  := 'Asignacion de Avales por Grupo Exitosa.';

Open CURSORGRABAVALES;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        CICLO:LOOP
        Fetch CURSORGRABAVALES  Into
            Var_GrupoID,    Var_SolCredID,  Var_ClienteID,  Var_ProspectoID;

            -- Antes de dar de Alta los Integrantes del Grupo como Avales Cruzados
            -- Validamos que no lo haya Realizado el Usuario Manualmente
            if(Var_ClienteID <> Entero_Cero) then

                set Var_CteAsigna := (select Avs.ClienteID
                    from AVALESPORSOLICI Avs
                    where Avs.SolicitudCreditoID = Par_SoliciCredID
                      and Avs.ClienteID = Var_ClienteID);

           else

                set Var_ProspeAsigna := (select Avs.ProspectoID
                    from AVALESPORSOLICI Avs
                    where Avs.SolicitudCreditoID = Par_SoliciCredID
                      and Avs.ProspectoID = Var_ProspectoID);

            end if;

            set Var_CteAsigna       := ifnull(Var_CteAsigna, Entero_Cero);
            set Var_ProspeAsigna    := ifnull(Var_ProspeAsigna, Entero_Cero);

            -- Si no existia la Relacion de Aval, entonces la damos de alta
            if(Var_CteAsigna = Entero_Cero and Var_ProspeAsigna = Entero_Cero ) then
                call AVALESPORSOLIALT(
                    Par_SoliciCredID,   Entero_Cero,        Var_ClienteID,      Var_ProspectoID,
                    Aval_Autori,		Var_RelOtParen,		Var_DecCeroUno,		SalidaNO,
					Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion  );

                if (Par_NumErr <> Entero_Cero)then
                    LEAVE CICLO;
                end if;

            end if;

        End LOOP CICLO;
    END;
Close CURSORGRABAVALES;

-- Si no hubo Errores Previos
if (Par_NumErr  = Entero_Cero ) then
    -- Valida que se tengan los Avales Adicionales a los Avales Cruzados del Propio Grupo
    -- En caso de que el producto de credito asi lo Indique
    if (Par_ReqAvales = Req_AvalesSI ) then

        select count(Estatus) into Var_TotAsiAvales
            from AVALESPORSOLICI
            where SolicitudCreditoID = Par_SoliciCredID
              and Estatus = Aval_Autori;

        set Var_TotAsiAvales    := ifnull(Var_TotAsiAvales, Entero_Cero);

        if ( Var_TotAsiAvales < Par_NumIntegra ) then
            set Par_NumErr := '001';
            set Par_ErrMen := concat("La Solicitud: ", convert(Par_SoliciCredID, char),
                                     ", Requiere Avales Adicionales.");
        end if;

    end if;
end if;

if (Par_Salida = SalidaSI) then
    select convert(Par_NumErr, char) as NumErr,
			  Par_ErrMen as ErrMen,
			  'grupoID' as control;
end if;


END TerminaStore$$