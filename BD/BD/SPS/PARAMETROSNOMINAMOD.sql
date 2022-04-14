-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSNOMINAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSNOMINAMOD`;
DELIMITER $$


CREATE PROCEDURE `PARAMETROSNOMINAMOD`(
# ==============================================================
# ---- STORE PARA LA MODIFICACION DE PARAMETROS DE NOMINA ------
# ==============================================================
  Par_EmpresaID           INT(11),       -- ID Empresa
  Par_Correo              VARCHAR(50),   -- Correo Electronico de la Empresa
  Par_CtaTransito         VARCHAR(25),   -- Cuenta Contable en Transito para los Depositos en Banco de Nomina
  Par_NomenclaturaCR      VARCHAR(30),   -- Nomenclura Centro de Costo
  Par_TipoMovTeso         CHAR(4),       -- ID del Tipo de Movimiento de Conciliacion

  Par_PerfilAutCalend     INT(11),
  Par_CtaTransDomicilia   VARCHAR(25),  -- Cuenta Contable en Transito para Domiciliacion de Pagos
  Par_TipoMovDomiciliaID  CHAR(4),      -- ID del Tipo de Movimiento de Domiciliacion de Pagos 


  Par_Salida            CHAR(1),        -- Indica el tipo de salida S.- Si N.- No
  INOUT Par_NumErr      INT(11),        -- Numero de Error
  INOUT Par_ErrMen      VARCHAR(400),   -- Mensaje de Error

  Aud_Usuario           INT(11),        -- Parametro de auditoria ID del usuario
  Aud_FechaActual       DATETIME,       -- Parametro de auditoria Fecha actual
  Aud_DireccionIP       VARCHAR(15),    -- Parametro de auditoria Direccion IP 
  Aud_ProgramaID        VARCHAR(50),    -- Parametro de auditoria Programa 
  Aud_Sucursal          INT(11),        -- Parametro de auditoria ID de la sucursal
  Aud_NumTransaccion    BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
	)

TerminaStore: BEGIN

DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE SalidaSI        char(1);
DECLARE SalidaNO        char(1);

DECLARE Var_Control           	VARCHAR(200);
DECLARE Var_CtaContable         VARCHAR(25);
DECLARE Var_Movimiento          VARCHAR(4);
DECLARE Var_PerfilAutoCal	      INT(11);

DECLARE Var_CtaTransDomicilia   VARCHAR(25);
DECLARE Var_TipoMovDomiciliaID  CHAR(4);


SET Entero_Cero  	:= 0;
SET SalidaSI     	:= 'S';
SET SalidaNO     	:= 'N';
SET Cadena_Vacia 	:='';

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-PARAMETROSNOMINAMOD');
			SET Var_Control = 'sqlException' ;
	END;

IF(ifnull(Par_CtaTransito,Cadena_Vacia) != Cadena_Vacia) THEN
        -- valida la Cuenta Constable EspecIFicada
				CALL CUENTASCONTABLESVAL(	Par_CtaTransito, SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
											            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
											            Aud_NumTransaccion);
				-- Validamos la respuesta
        IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr  := '001';
          SET Par_ErrMen  := concat(Par_ErrMen, '(Cta. Contable Tránsito).');
					SET Var_Control := 'cuentaCompletaID';
					LEAVE ManejoErrores;
				END IF;
      ELSE
            SET Par_NumErr := '001';
            SET Par_ErrMen :='La Cuenta en Transito esta Vacia.';
            SET Var_Control := 'ctaPagoTransito';
            LEAVE ManejoErrores;
END IF;

IF(ifnull(Par_Correo,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := '002';
            SET Par_ErrMen :='El Correo del Encargado de Nomina esta Vacio.';
            SET Var_Control := 'correoElectronico';
            LEAVE ManejoErrores;
END IF;

SET Var_CtaContable := (SELECT CuentaCompleta
                                FROM CUENTASCONTABLES
                                    WHERE CuentaCompleta =Par_CtaTransito);
IF(ifnull(Var_CtaContable,Cadena_Vacia)=Cadena_Vacia) THEN
            SET Par_NumErr := '003';
            SET Par_ErrMen :='La Cuenta Contable No Existe.';
            SET Var_Control := 'ctaPagoTransito';
            LEAVE ManejoErrores;

END IF;

IF(ifnull(Par_TipoMovTeso,Cadena_Vacia) = Cadena_Vacia) THEN
            SET Par_NumErr := '004';
            SET Par_ErrMen :='El Tipo de Movimiento esta Vacia.';
            SET Var_Control := 'tipoMovimiento';
            LEAVE ManejoErrores;
END IF;

SET Var_Movimiento := (select TipoMovTesoID
						from TIPOSMOVTESO
							where TipoMovTesoID = Par_TipoMovTeso);
IF(ifnull(Var_Movimiento,Cadena_Vacia)=Cadena_Vacia) THEN
            SET Par_NumErr := '005';
            SET Par_ErrMen :='El Tipo de Movimiento No Existe.';
            SET Var_Control := 'tipoMovimiento';
            LEAVE ManejoErrores;

END IF;

IF(ifnull(Par_NomenclaturaCR, Cadena_Vacia))= Cadena_Vacia then
		SET Par_NumErr := '006';
		SET Par_ErrMen :='La Nomenclatura esta Vacia.';
		SET Var_Control := 'nomenclaturaCR';
		LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_CtaTransDomicilia,Cadena_Vacia) != Cadena_Vacia) THEN
        -- valida la Cuenta Constable EspecIFicada
				CALL CUENTASCONTABLESVAL(	Par_CtaTransDomicilia,	SalidaNO,		Par_NumErr,			Par_ErrMen,			Par_EmpresaID,
											            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	
											            Aud_NumTransaccion);
        -- Validamos la respuesta
				IF(Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr  := '009';
          SET Par_ErrMen  := concat(Par_ErrMen, '(Cta. Contable Tránsito para Domiciliacion).');
					SET Var_Control := 'ctaTransDomicilia';
					LEAVE ManejoErrores;
				END IF;
ELSE
        SET Par_NumErr  := '009';
        SET Par_ErrMen  := 'La Cuenta Contable en Transito para Domiciliacion esta Vacia.';
        SET Var_Control := 'ctaTransDomicilia';
        LEAVE ManejoErrores;
END IF;
    
SET Var_CtaTransDomicilia := (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CtaTransDomicilia);
IF(IFNULL(Var_CtaTransDomicilia,Cadena_Vacia) = Cadena_Vacia) THEN
  SET Par_NumErr  := 014;
  SET Par_ErrMen  := 'La Cuenta Contable en Transito para Domiciliacion No Existe.';
  SET Var_Control := 'ctaTransDomicilia';
  LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_TipoMovDomiciliaID,Cadena_Vacia) = Cadena_Vacia) THEN
  SET Par_NumErr  := 015;
  SET Par_ErrMen  := 'El Tipo de Movimiento de Domiciliacion esta Vacio.';
  SET Var_Control := 'tipoMovDomiciliaID';
  LEAVE ManejoErrores;
END IF;

SET Var_TipoMovDomiciliaID := (SELECT TipoMovTesoID FROM TIPOSMOVTESO WHERE TipoMovTesoID = Par_TipoMovDomiciliaID);
IF(IFNULL(Var_TipoMovDomiciliaID,Cadena_Vacia) = Cadena_Vacia) THEN
  SET Par_NumErr  := 016;
  SET Par_ErrMen  := 'El Tipo de Movimiento de Domiciliacion No Existe.';
  SET Var_Control := 'tipoMovDomiciliaID';
  LEAVE ManejoErrores;
END IF;

IF(IFNULL(Par_PerfilAutCalend,Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr := '007';
            SET Par_ErrMen :='El Perfil de Autorizacion de Calendario esta Vacia.';
            SET Var_Control := 'perfilAutoCalend';
            LEAVE ManejoErrores;
END IF;

SET Var_PerfilAutoCal := (SELECT RolID FROM ROLES WHERE RolID = Par_PerfilAutCalend);

IF(IFNULL(Var_PerfilAutoCal,Entero_Cero)=Entero_Cero) THEN
            SET Par_NumErr := '008';
            SET Par_ErrMen :='El Perfil de Autorizacion de Calendario No Existe en TABLA ROLES';
            SET Var_Control := 'perfilAutoCalend';
            LEAVE ManejoErrores;

END IF;


  UPDATE PARAMETROSNOMINA SET
    CorreoElectronico     = Par_Correo,
    CtaPagoTransito       = Par_CtaTransito,
    NomenclaturaCR        = Par_NomenclaturaCR,
    TipoMovTesCon         = Par_TipoMovTeso,
    PerfilAutCalend	      = Par_PerfilAutCalend,

    CtaTransDomicilia     = Par_CtaTransDomicilia,  
    TipoMovDomiciliaID    = Par_TipoMovDomiciliaID, 

    Usuario               = Aud_Usuario,
    FechaActual           = Aud_FechaActual,
    DireccionIP           = Aud_DireccionIP,
    ProgramaID            = Aud_ProgramaID,
    Sucursal              = Aud_Sucursal,
    NumTransaccion        = Aud_NumTransaccion

   WHERE EmpresaID = Par_EmpresaID;

         SET Par_NumErr := '000';
         SET Par_ErrMen :=concat('Parametros Modificados Exitosamente: ', Par_EmpresaID,'.');
         SET Var_Control := 'empresaID';
         SET Entero_Cero := Par_EmpresaID;
         LEAVE ManejoErrores;

END ManejoErrores;

if (Par_Salida = SalidaSI) then
    select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$
