-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOGARSINFONDEOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOGARSINFONDEOPRO`;DELIMITER $$

CREATE PROCEDURE `CREDITOGARSINFONDEOPRO`(
	Par_CreditoID			bigint,  -- identificador del credito
    Par_TipoGarantia		int,	 -- indica el tipo de garantia que se contrato
    Par_Cancelado			char(1), -- indica si se cancela la contratación de garantias,

    Par_Salida              CHAR(1),			-- Salida
	INOUT Par_NumErr        INT,				-- Salida
	INOUT Par_ErrMen        VARCHAR(400),		-- Salida

	Par_EmpresaID			INT,				-- Auditoria
	Aud_Usuario				INT, 				-- Auditoria
	Aud_FechaActual			DATETIME, 			-- Auditoria
	Aud_DireccionIP			VARCHAR(15),	 	-- Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Auditoria
	Aud_Sucursal			INT,				-- Auditoria
	Aud_NumTransaccion		BIGINT				-- Auditoria
)
TerminaStore: BEGIN
	Declare Var_EstatusGar 		char(1);		 -- estatus de la garantia
	Declare VarControl 			varchar(25); 	 -- variable de control de formulario


    declare Est_Autorizado		char(1);
    declare Est_Cancelado		char(1);
    declare Cadena_Vacia		char(1);
    declare Con_SI				char(1);
    declare Tipo_Ninguna		int;
    declare Entero_Cero			int;

    set Est_Autorizado			:= 'A';
    set Est_Cancelado			:= 'C';
    set Con_SI					:= 'S';
    set Tipo_Ninguna			:= 0;	-- Indica que no se contrato ninguna garantia
	set Entero_Cero				:= 0;
    set Cadena_Vacia			:= '';
	set Var_EstatusGar			:= Est_Autorizado;

	ManejoErrores:begin

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
						'esto le ocasiona. Ref: SP-CREDITOGARSINFONDEOPRO');
				SET VarControl := 'sqlException' ;
			END;

            if ifnull(Par_CreditoID,Entero_Cero)  = Entero_Cero  then
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'Numero de Credito vacio';
				SET VarControl := 'creditoID' ;
                leave ManejoErrores;
            end if;

            if ifnull(Par_TipoGarantia,Entero_Cero)  = Entero_Cero  then
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'Tipo de Garantia vacio';
				SET VarControl := 'tipoGarantiaID' ;
                leave ManejoErrores;
            end if;

            if ifnull(Par_Cancelado,Cadena_Vacia)  = Cadena_Vacia  then
				SET Par_NumErr := 3;
				SET Par_ErrMen := 'Tipo de Garantia vacio';
				SET VarControl := 'tipoGarantiaID' ;
                leave ManejoErrores;
            end if;


            if  Par_Cancelado = Con_SI then
                set Par_TipoGarantia	:= Tipo_Ninguna;
                set Var_EstatusGar		:= Est_Cancelado;
            end if;


			UPDATE CREDITOS set
				TipoGarantiaFIRAID  = Par_TipoGarantia,
                EstatusGarantiaFIRA = Var_EstatusGar
			where CreditoID = Par_CreditoID;

			SET Par_NumErr = 0;
			SET Par_ErrMen = CONCAT('Garantias de Creditos Procesadas Exitosamente');
			SET VarControl = 'creditoID' ;

    end ManejoErrores;

	IF(Par_Salida = Con_SI) THEN
	 SELECT Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			VarControl AS Control,
			Entero_Cero AS Consecutivo;
	END IF;

END TerminaStore$$