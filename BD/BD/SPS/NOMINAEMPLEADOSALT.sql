-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSALT`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSALT`(
	Par_InstitNominaID	INT(11),
	Par_ClienteID		INT(11),
	Par_ProspectoID		BIGINT(20),
	Par_ConvNominaID	BIGINT UNSIGNED,		-- Identificador del convenio de nomina
	Par_TipoEmpleadoID	INT(11),		-- Identificador del tipo de empleado de la tabla TIPOSEMPLEADOS

    Par_TipoPuestoID	INT(11),		-- Identificador del tipo de puesto del empleado de la tabla CATPUESTOSOCUPACION
	Par_NoEmpleado		VARCHAR(30),	-- Numero de empleado en su empresa de nomina
	Par_QuinquenioID	INT(11),		-- Quinquenio
    Par_CenAdscripcion	VARCHAR(100),	-- Centro de adscripcion
	Par_FechaIngreso	DATE,			-- Fecha de ingreso
	Par_NoPension		VARCHAR(25),	-- Numero de Pension

	Par_Salida          CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
	)

TerminaStore: BEGIN


DECLARE Var_InstitNominaID  	VARCHAR(20);
DECLARE Var_Control         	VARCHAR(100);
DECLARE Var_Consecutivo         INT(11);
DECLARE Var_NominaEmpleadoID	INT(11);		-- Variable para generar el ID del registro
DECLARE Var_ClienteID			INT(11);		-- Variable para obtener el identificador del cliente
DECLARE Var_FechaSistema		DATE;			-- Fecha de sistema
DECLARE Var_ManejaConvenio     	VARCHAR(200);
DECLARE Var_NoEmpleado			VARCHAR(30);
DECLARE Var_ConvNominaID		BIGINT UNSIGNED;

DECLARE Estatus_Activo  		CHAR(1);
DECLARE Cadena_Vacia    		CHAR(1);
DECLARE Entero_Cero     		INT(11);
DECLARE SalidaSI        		CHAR(1);
DECLARE SalidaNO        		CHAR(1);
DECLARE	Fecha_Vacia				date;
DECLARE Est_Reasignado			CHAR(1);				-- Estatus reasignado
DECLARE Cons_NO					CHAR(1);


Set Estatus_Activo  := 'A';
Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
Set SalidaNO        := 'N';
Set	Fecha_Vacia		:= '1900-01-01';
SET Est_Reasignado	:= 'R';						-- Estatus reasignado
SET Cons_NO			:= 'N';

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-NOMINAEMPLEADOSALT');
			SET Var_Control = 'sqlException' ;
			END;
		SELECT ValorParametro INTO Var_ManejaConvenio
		FROM PARAMGENERALES AS PAR
		WHERE PAR.LlaveParametro = 'ManejaCovenioNomina';
        SET Var_ManejaConvenio := IFNULL(Var_ManejaConvenio, Cons_NO);

		SET Par_ClienteID		:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_QuinquenioID 	:= IFNULL(Par_QuinquenioID, Entero_Cero);
		SET Par_CenAdscripcion	:= IFNULL(Par_CenAdscripcion, Cadena_Vacia);
		SET Par_NoPension		:= IFNULL(Par_NoPension, Cadena_Vacia);

		IF(Par_ClienteID != Entero_Cero) then
		 if(NOT EXISTS(SELECT ClienteID
							from CLIENTES
								where ClienteID = Par_ClienteID)) then
				SET Par_NumErr 		:= 001;
				SET Par_ErrMen  	:= 'El cliente especificado no existe';
				SET Var_Control 	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_ProspectoID  := IFNULL(Par_ProspectoID, Entero_Cero);

		IF(Par_ProspectoID != Entero_Cero) then
		SELECT		NominaEmpleadoID
			INTO	Var_NominaEmpleadoID
			FROM	NOMINAEMPLEADOS
			WHERE	InstitNominaID	= Par_InstitNominaID
			  AND	ProspectoID		= Par_ProspectoID
			  AND	Estatus			<> Est_Reasignado
			LIMIT 0, 1;
		 IF(NOT EXISTS(SELECT ProspectoID
							FROM PROSPECTOS
								WHERE ProspectoID = Par_ProspectoID)) THEN
				SET Par_NumErr 		:= 002;
				SET Par_ErrMen  	:= 'El prospecto especificado no existe';
				SET Var_Control 	:= 'prospectoID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_ClienteID = Entero_Cero) THEN
		SELECT		NominaEmpleadoID
			INTO	Var_NominaEmpleadoID
			FROM	NOMINAEMPLEADOS
			WHERE	InstitNominaID	= Par_InstitNominaID
			  AND	ClienteID		= Par_ClienteID
			  AND	Estatus			<> Est_Reasignado
			LIMIT 0, 1;

			if(Par_ProspectoID = Entero_Cero) THEN
				SET Par_NumErr 		:= 003;
				SET Par_ErrMen  	:= 'Se Requiere un Cliente o un Prospecto';
				SET Var_Control 	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_ClienteID>0 AND Var_ManejaConvenio=Cons_NO) THEN
			SELECT		NominaEmpleadoID
				INTO	Var_NominaEmpleadoID
				FROM	NOMINAEMPLEADOS
				WHERE	InstitNominaID	= Par_InstitNominaID
				  AND	ClienteID		= Par_ClienteID
				  AND	Estatus			<> Est_Reasignado
				LIMIT 0, 1;
		END IF;
		
        SET Var_NominaEmpleadoID	:= IFNULL(Var_NominaEmpleadoID, Entero_Cero);

		IF (Var_NominaEmpleadoID <> Entero_Cero) THEN
			SET Par_NumErr	:= 004;
			SET Par_ErrMen	:= 'El cliente ya se encuentra asociado a la empresa de nomina';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;
            
		SET Var_NominaEmpleadoID	:= Entero_Cero;

		SET Par_NoEmpleado	:= IFNULL(Par_NoEmpleado, Cadena_Vacia);

		IF (Par_NoEmpleado != Cadena_Vacia) THEN
			SELECT		ClienteID, 		ConvenioNominaID
				INTO	Var_ClienteID, 	Var_ConvNominaID
				FROM	NOMINAEMPLEADOS
				WHERE	InstitNominaID	= Par_InstitNominaID
                  AND 	ConvenioNominaID = Par_ConvNominaID
                  AND	ClienteID		= Par_ClienteID
				  AND	Estatus			<> Est_Reasignado
				LIMIT 0, 1;

			SET Var_ClienteID	:= IFNULL(Var_ClienteID, Entero_Cero);
			SET Var_ConvNominaID:= IFNULL(Var_ConvNominaID, Entero_Cero);
			
            IF (Var_ClienteID != Entero_Cero) THEN
				SET Par_NumErr	:= 005;
				SET Par_ErrMen	:= CONCAT('El cliente ', Var_ClienteID, ' ya se encuentra registrado con el numero de empleado ', Par_NoEmpleado,' y convenio ',Var_ConvNominaID);
				SET Var_Control	:= 'convenioNominaID';
				LEAVE ManejoErrores;
			END IF;
            
            SELECT		NoEmpleado
				INTO	Var_NoEmpleado
				FROM	NOMINAEMPLEADOS
				WHERE	InstitNominaID	= Par_InstitNominaID
                  AND	ClienteID		= Par_ClienteID
				  AND	Estatus			<> Est_Reasignado
				LIMIT 0, 1;
			SET Var_NoEmpleado := IFNULL(Var_NoEmpleado, Cadena_Vacia);
            
			IF (Var_NoEmpleado != Cadena_Vacia AND Var_NoEmpleado!=Par_NoEmpleado) THEN
				SET Par_NumErr	:= 006;
				SET Par_ErrMen	:= CONCAT('El cliente ', Par_ClienteID, ' ya se encuentra registrado con el numero de empleado ', Var_NoEmpleado,'.');
				SET Var_Control	:= 'noEmpleado';
				LEAVE ManejoErrores;
			END IF;
           
		END IF;

		SELECT		FechaSistema
			INTO	Var_FechaSistema
			FROM	PARAMETROSSIS;

        IF(Var_ManejaConvenio=Cons_NO)THEN
			SET Par_ConvNominaID := NULL;
		END IF;

		CALL FOLIOSAPLICAACT('NOMINAEMPLEADOS', Var_NominaEmpleadoID);

		INSERT INTO NOMINAEMPLEADOS (	NominaEmpleadoID,		InstitNominaID,		ClienteID,			ProspectoID,		ConvenioNominaID,
										TipoEmpleadoID,			TipoPuestoID,		NoEmpleado,			Estatus,			FechaInicioInca,
										FechaFinInca,			FechaBaja,			MotivoBaja,			QuinquenioID, 		CentroAdscripcion,
                                        FechaIngreso,			NoPension,
                                        EmpresaID,				Usuario,			FechaActual,		DireccionIP,		ProgramaID,
                                        Sucursal,				NumTransaccion)
			VALUES(						Var_NominaEmpleadoID,	Par_InstitNominaID,	Par_ClienteID,		Par_ProspectoID,	Par_ConvNominaID,
										Par_TipoEmpleadoID,		Par_TipoPuestoID,	Par_NoEmpleado,		Estatus_Activo,		Fecha_Vacia,
										Fecha_Vacia,			Fecha_Vacia,		Cadena_Vacia,		Par_QuinquenioID, 	Par_CenAdscripcion,
                                        Par_FechaIngreso,		Par_NoPension,
                                        Par_EmpresaID,  		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
                                        Aud_Sucursal,			Aud_NumTransaccion);

		SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Empleado de Nomina Agregado';
        SET Var_Control := 'clienteID';
		SET Entero_Cero := Par_ClienteID;


END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$
