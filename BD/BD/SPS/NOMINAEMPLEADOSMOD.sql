-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `NOMINAEMPLEADOSMOD`;
DELIMITER $$


CREATE PROCEDURE `NOMINAEMPLEADOSMOD`(
	Par_NominaEmpleadoID INT(11),		-- Nomina Empleado

    Par_InstitNominaID	INT(11),		-- Institucion
	Par_ClienteID		INT(11),		-- Cliente
	Par_ProspectoID		BIGINT(20),		-- Prospecto
	Par_ConvNominaID	BIGINT UNSIGNED, -- Identificador del convenio de nomina
	Par_TipoEmpleadoID	INT(11),		-- Identificador del tipo de empleado de la tabla TIPOSEMPLEADOS

	Par_TipoPuestoID	INT(11),		-- Identificador del tipo de puesto del empleado de la tabla CATPUESTOSOCUPACION
	Par_NoEmpleado		VARCHAR(30),	-- Numero de empleado en su empresa de nomina
	Par_QuinquenioID	INT(11),		-- Quinquenio
	Par_CenAdscripcion	VARCHAR(100),	-- Centro de adscripcion
	Par_FechaIngreso	DATE,			-- Fecha de ingreso

	Par_Estatus			CHAR(1),		-- Estatus del empleado de nomina
	Par_FechaInicioInca	DATE,			-- Fecha de Inicio incapacidad
	Par_FechaFinInca	DATE,			-- Fecha final de la incapacidad
	Par_FechaBaja		DATE,			-- Fecha de baja
	Par_MotivoBaja		VARCHAR(200),	-- Motivo de baja
	Par_NoPension		VARCHAR(25),	-- Numero de Pension

	Par_Salida          CHAR(1),		-- Salida
	INOUT Par_NumErr	INT(11),		-- Numerod de error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de error
	Aud_EmpresaID		INT(11),		-- Auditoria
	Aud_Usuario			INT(11),		-- Auditoria

	Aud_FechaActual		DATETIME,		-- Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Auditoria
	Aud_Sucursal		INT(11),		-- Auditoria
	Aud_NumTransaccion	BIGINT			-- Auditoria
	)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_InstitNominaID  VARCHAR(20);
	DECLARE Var_Control         VARCHAR(100);
	DECLARE Var_Consecutivo     INT(11);
	DECLARE Var_CorreoProm      VARCHAR(100);
	DECLARE Var_ClienteID		INT(11);
	DECLARE Var_EstatusAnt		CHAR(1);
    DECLARE Var_NoEmpleado		VARCHAR(30);
	DECLARE Var_ConvNominaID	BIGINT UNSIGNED;
	DECLARE Var_ConvNominaAntID	BIGINT UNSIGNED;
    DECLARE Var_ManejaConvenio  VARCHAR(200);
    
	-- Declaracion de constantes
    DECLARE Est_Reasignado		CHAR(1);				-- Estatus reasignado
	DECLARE Estatus_Activo  	CHAR(1);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Entero_Cero     	INT(11);
	DECLARE SalidaSI        	CHAR(1);
	DECLARE SalidaNO        	CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE FechaSist       	DATE;
    DECLARE Cons_NO				CHAR(1);
    DECLARE Cons_SI				CHAR(1);

	-- Asignacion de constantes
    SET Est_Reasignado	:= 'R';
	SET Estatus_Activo  := 'A';
	SET Cadena_Vacia    := '';
	SET Entero_Cero     := 0;
	SET SalidaSI        := 'S';
	SET SalidaNO        := 'N';
	SET	Fecha_Vacia		:= '1900-01-01';
    SET Cons_NO			:= "N";
    SET Cons_SI			:= "S";


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
									 'estamos trabajando para resolverla. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-NOMINAEMPLEADOSMOD');
			SET Var_Control = 'sqlException' ;
		END;
		
        SELECT ValorParametro INTO Var_ManejaConvenio
			FROM PARAMGENERALES AS PAR
			WHERE PAR.LlaveParametro = 'ManejaCovenioNomina';
        SET Var_ManejaConvenio := IFNULL(Var_ManejaConvenio, Cons_NO);
        
		SET FechaSist 		:= (SELECT FechaSistema FROM PARAMETROSSIS);
		SET Par_NoPension	:= IFNULL(Par_NoPension, Cadena_Vacia);

		IF(NOT EXISTS(SELECT InstitNominaID
						FROM INSTITNOMINA
							WHERE InstitNominaID= Par_InstitNominaID)) THEN
			SET Par_NumErr 		:= 001;
			SET Par_ErrMen  	:= 'La Institucion especificada no existe';
			SET Var_Control 	:= 'institNominaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT ClienteID INTO Var_ClienteID
			FROM NOMINAEMPLEADOS
			WHERE ClienteID=Par_ClienteID
			AND InstitNominaID=Par_InstitNominaID LIMIT 1;

		IF(IFNULL(Var_ClienteID, Entero_Cero)) = Entero_Cero THEN
			SELECT ProspectoID INTO Var_ClienteID
				FROM NOMINAEMPLEADOS
				WHERE ProspectoID=Par_ClienteID
				AND InstitNominaID=Par_InstitNominaID LIMIT 1;
		END IF;

		SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);

		IF(Var_ClienteID = Entero_Cero) then
			if(Var_ClienteID = Entero_Cero ) then
				SET Par_NumErr 		:= 002;
				SET Par_ErrMen  	:= 'El Cliente No Existe';
				SET Var_Control 	:= 'clienteID';
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Var_EstatusAnt := (SELECT  Estatus
									FROM NOMINAEMPLEADOS
									WHERE ClienteID = Par_ClienteID
									AND InstitNominaID= Par_InstitNominaID LIMIT 1);
		END IF;


		
		
        
        
		SET Aud_FechaActual := NOW();
		-- MODIFICACION DE DATOS
		IF(Par_Estatus = Cadena_Vacia)THEN
/************************************************************************
*			 	VALIDACIONES COVENIOS DE NOMINA							*
*************************************************************************/			
            IF(Par_ClienteID>0 AND Var_ManejaConvenio=Cons_SI) THEN
            
				SELECT ConvenioNominaID INTO Var_ConvNominaAntID
					FROM NOMINAEMPLEADOS 
                    WHERE NominaEmpleadoID=Par_NominaEmpleadoID;
                    
                SET Var_ConvNominaAntID := IFNULL(Var_ConvNominaAntID, Entero_Cero);
                SET Var_ClienteID := Entero_Cero;
                -- VALIDAMOS QUE EL CONVENIO SEA DISTINTO AL ANTERIOR
                IF(Var_ConvNominaAntID !=Par_ConvNominaID)THEN 
					SELECT		ClienteID, 		ConvenioNominaID
						INTO	Var_ClienteID, 	Var_ConvNominaID
						FROM	NOMINAEMPLEADOS
						WHERE	InstitNominaID	= Par_InstitNominaID
						  AND 	ConvenioNominaID = Par_ConvNominaID
						  AND 	(ConvenioNominaID != Var_ConvNominaID AND ConvenioNominaID>0)
						  AND	ClienteID		= Par_ClienteID
						  AND	Estatus			<> Est_Reasignado
						LIMIT 0, 1;

					SET Var_ClienteID	:= IFNULL(Var_ClienteID, Entero_Cero);
					SET Var_ConvNominaID:= IFNULL(Var_ConvNominaID, Entero_Cero);
                END IF;
                    
				
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
			
			IF(Var_ManejaConvenio=Cons_NO)THEN
				SET Par_ConvNominaID := NULL;
				SET Var_ConvNominaAntID := NULL;
			END IF;
			
/************************************************************************
*			FIN VALIDACIONES COVENIOS DE NOMINA							*
*************************************************************************/
			UPDATE NOMINAEMPLEADOS SET
				InstitNominaID		= Par_InstitNominaID,
				ClienteID			= Par_ClienteID,
				ProspectoID			= Par_ProspectoID,
				ConvenioNominaID	= Par_ConvNominaID,
				TipoEmpleadoID		= Par_TipoEmpleadoID,
				TipoPuestoID		= Par_TipoPuestoID,
				QuinquenioID		= Par_QuinquenioID,
				CentroAdscripcion	= Par_CenAdscripcion,
				FechaIngreso		= Par_FechaIngreso,
				NoPension 			= Par_NoPension,
				NoEmpleado			=	Par_NoEmpleado,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE InstitNominaID = Par_InstitNominaID
			AND (ClienteID = Par_ClienteID OR ProspectoID=Par_ClienteID)
            AND ConvenioNominaID = Var_ConvNominaAntID;
		END IF;

		-- CAMBIO DE ESTATUS
		IF(Par_Estatus != Cadena_Vacia)THEN

			SET Par_FechaInicioInca   := IFNULL(Par_FechaInicioInca, Cadena_Vacia);
			IF(Par_FechaInicioInca = Cadena_vacia) THEN
				SET Par_FechaInicioInca	:=	Fecha_vacia;
			END IF;

			SET Par_FechaFinInca   := IFNULL(Par_FechaFinInca, Cadena_Vacia);
			IF(Par_FechaFinInca = Cadena_vacia) then
				SET Par_FechaFinInca	:=	Fecha_vacia;
			END IF;

			SET Par_FechaBaja   := IFNULL(Par_FechaBaja, Cadena_Vacia);
			IF(Par_FechaBaja = Cadena_vacia) THEN
				SET Par_FechaBaja	:=	Fecha_vacia;
			END IF;


			UPDATE NOMINAEMPLEADOS SET
						Estatus			=	Par_Estatus,
						FechaInicioInca	=	Par_FechaInicioInca	,
						FechaFinInca	=	Par_FechaFinInca,
						FechaBaja		=	Par_FechaBaja,
						MotivoBaja		=	Par_MotivoBaja,
						NoPension 		=	Par_NoPension,

						EmpresaID		=	Aud_EmpresaID,
						Usuario			= 	Aud_Usuario,
						FechaActual		=	Aud_FechaActual,
						DireccionIP		=	Aud_DireccionIP,
						ProgramaID		=	Aud_ProgramaID,
						Sucursal		=	Aud_Sucursal,
						NumTransaccion	=	Aud_NumTransaccion
			WHERE InstitNominaID= Par_InstitNominaID
			AND (ClienteID = Par_ClienteID OR ProspectoID=Par_ClienteID);

			INSERT INTO NOMBITACOESTEMP(
							InstitNominaID,			ClienteID,				Fecha,			EstatusAnterior,	EstatusNuevo,
							FechaInicioIncapacidad,	FechaFinIncapacidad,	FechaBaja,		MotivoBaja,			EmpresaID,
							Usuario,				FechaActual,			DireccionIP, 	ProgramaID,			Sucursal,
							NumTransaccion
						)
				SELECT		InstitNominaID, 		ClienteID,				FechaSist,		Var_EstatusAnt, 	Estatus,
							FechaInicioInca,		FechaFinInca,   		FechaBaja, 		MotivoBaja ,  		EmpresaID,
							Usuario,				FechaActual, 			DireccionIP,	ProgramaID,			Sucursal,
							NumTransaccion
				FROM NOMINAEMPLEADOS
				WHERE InstitNominaID= Par_InstitNominaID
				AND ClienteID = Par_ClienteID;

		END IF;

		SET Par_NumErr  := 000;
		SET Par_ErrMen	:= CONCAT("Empleado Modificado Exitosamente: ", CONVERT(Par_ClienteID, CHAR));
		SET Var_Control := 'clienteID';
		SET Entero_Cero := Par_ClienteID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) then
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$