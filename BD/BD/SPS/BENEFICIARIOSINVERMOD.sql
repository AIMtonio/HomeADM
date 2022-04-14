-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVERMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOSINVERMOD`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOSINVERMOD`(
    Par_BenefInverID     int(11),
    Par_InversionID     int(11),
    Par_ClienteID       int(11),
    Par_Titulo          varchar(10),
    Par_PrimerNombre    varchar(50),
    Par_SegundoNombre   varchar(50),
    Par_TercerNombre    varchar(50),
    Par_PrimerApellido  varchar(50),
    Par_SegundoApellido varchar(50),
    Par_FechaNacimiento date,
    Par_PaisID          int(5),
    Par_EstadoID        int(5),
    Par_EstadoCivil     char(2),
    Par_Sexo            char(1),
    Par_CURP            char(18),
    Par_RFC             char(13),
    Par_OcupacionID     int(11),
    Par_ClavePuestoID   varchar(200),
    Par_TipoIdentiID    int(11),
    Par_NumIdentific    varchar(30),
    Par_FecExIden       date,
    Par_FecVenIden      date	,
    Par_TelefonoCasa    varchar(20),
    Par_TelefonoCelular varchar(20),
    Par_Correo          varchar(50),
    Par_Domicilio       varchar(500),
    Par_TipoRelacionID  int(11),
    Par_Porcentaje      decimal(12,2),
    Par_TipoBene			char(1),

    Par_Salida          char(1),
    INOUT Par_NumErr    int,
    INOUT Par_ErrMen    varchar(400),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

    	)
TerminaStore: BEGIN


Declare varControl          varchar(50);
Declare Var_BeneInverID     int(11);
Declare Var_EstatusInver	char(1);
declare Var_Porcentaje		decimal(14,2);
DECLARE Var_Total_Porcentaje	decimal(14,2);
Declare Var_NombreCompleto  	char(200);


Declare Entero_Cero     int;
Declare Decimal_Cero		decimal(14,2);
Declare Cadena_Vacia		char(1);
Declare Fecha_Vacia     date;
Declare Salida_SI           char(1);
Declare Est_Vencida			char(1);
Declare Est_Pagada			char(1);
Declare Est_Cancelada		char(1);
Declare TotalPorcentaje		decimal(12,2);
DECLARE MenorEdad			char(1);


Set varControl          :='';


Set Entero_Cero     := 0;
Set Decimal_Cero    := 0.0;
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Salida_SI       := 'S';
set Est_Vencida		:='V';
Set Est_Pagada		:='P';
Set Est_Cancelada	:='C';
set TotalPorcentaje	:=100.0;
set MenorEdad		:= 'S';



ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = '999';
                SET Par_ErrMen = concat('Estimado Usuario(a), ha ocurrido una falla en el sistema, ' ,
										 'estamos trabajando para resolverla. Disculpe las molestias que ',
										 'esto le ocasiona. Ref: SP-BENEFICIARIOSINVERMOD');
                SET varControl = 'sqlException' ;
            END;

		set Aud_FechaActual	:=now();
        IF(ifnull(Par_InversionID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'El Numero de Inversion esta Vacio.';
            SET varControl  := 'inversionID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_BenefInverID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr  := '002';
            SET Par_ErrMen  := 'El Beneficiario esta vacio.';
            SET varControl  := 'beneInverID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_PrimerNombre,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '004';
            SET Par_ErrMen  := 'El Primer Nombre esta vacio.';
            SET varControl  := 'primerNombre' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_PrimerApellido, Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '005';
            SET Par_ErrMen  := 'El Primer Apellido esta vacio.';
            SET varControl  := 'primerApellido' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_Sexo,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '006';
            SET Par_ErrMen  := 'El Sexo esta vacio.';
            SET varControl  := 'sexo' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_CURP,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '007';
            SET Par_ErrMen  := 'El CURP esta vacio.';
            SET varControl  := 'curp' ;
            LEAVE ManejoErrores;
        END IF;


		IF EXISTS (SELECT ClienteID
					FROM CLIENTES
					WHERE ClienteID = Par_ClienteID
					AND EsMenorEdad != MenorEdad) THEN
						IF(ifnull(Par_RFC,Cadena_Vacia))= Cadena_Vacia THEN
							SET Par_NumErr  := '008';
							SET Par_ErrMen  := 'El RFC esta vacio.';
							SET varControl  := 'rfc' ;
							LEAVE ManejoErrores;
						END IF;
						IF(ifnull(Par_TipoIdentiID,Entero_Cero))= Entero_Cero THEN
							SET Par_NumErr  := '009';
							SET Par_ErrMen  := 'El Tipo de Identificacion esta vacio.';
							SET varControl  := 'tipoIdentifiID' ;
							LEAVE ManejoErrores;
						END IF;

						IF(ifnull(Par_NumIdentific,Cadena_Vacia))= Cadena_Vacia THEN
							SET Par_NumErr  := '010';
							SET Par_ErrMen  := 'El Numero de Identificacion esta vacio.';
							SET varControl  := 'numIdentific' ;
							LEAVE ManejoErrores;
						END IF;
        END IF;

        IF(ifnull(Par_Domicilio,Cadena_Vacia))= Cadena_Vacia THEN
            SET Par_NumErr  := '011';
            SET Par_ErrMen  := 'El Domicilio esta vacio.';
            SET varControl  := 'domicilio' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_TipoRelacionID,Entero_Cero))= Entero_cero THEN
            SET Par_NumErr  := '012';
            SET Par_ErrMen  := 'El Parenteco esta vacio.';
            SET varControl  := 'tipoRelacionID' ;
            LEAVE ManejoErrores;
        END IF;

        IF(ifnull(Par_Porcentaje,Entero_Cero))= Entero_cero THEN
            SET Par_NumErr  := '013';
            SET Par_ErrMen  := 'El Porcentaje esta vacio.';
            SET varControl  := 'porcentaje' ;
            LEAVE ManejoErrores;
        END IF;

		IF(Var_EstatusInver = Est_Pagada) then
				SET Par_NumErr  := '014';
				SET Par_ErrMen  := 'La Inversión está Pagada ';
				SET varControl  := 'inversionID';
				LEAVE ManejoErrores;
		end if;

		IF(Var_EstatusInver = Est_Cancelada) then
				SET Par_NumErr	:=	'015';
				SET Par_ErrMen	:= 'La Inversión está Cancelada';
				SET	varControl	:= 'inversionID';
				LEAVE ManejoErrores;
		end if;

		IF(Var_EstatusInver = Est_Vencida) then
			SET Par_NumErr	:= '016';
			SET Par_ErrMen	:=	'La Inversión esta Vencida';
			SET varControl	:= 'inversionID';
			LEAVE ManejoErrores;
		end if;
		Set Var_Porcentaje  := ifnull((select sum(Porcentaje)
										from BENEFICIARIOSINVER
										where InversionID = Par_InversionID
										and  BenefInverID <> Par_BenefInverID),Entero_Cero);

		SET Var_Total_Porcentaje :=Var_Porcentaje + Par_Porcentaje;
		IF(Var_Total_Porcentaje > TotalPorcentaje)then
            SET Par_NumErr  := '012';
            SET Par_ErrMen  := 'El Porcentaje Indicado Excede el Total a Otorgar ';
            SET varControl  := 'porcentaje';
            LEAVE ManejoErrores;
		end if;






        IF(Par_ClienteID = Entero_Cero) THEN

	   Set Var_NombreCompleto := concat(rtrim(ltrim(ifnull(Par_PrimerNombre, '')))
								,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_SegundoNombre, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_SegundoNombre, '')))) else '' end
								,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_TercerNombre, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_TercerNombre, '')))) else '' end
								,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_PrimerApellido, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_PrimerApellido, '')))) else '' end
								,case when CHAR_LENGTH(rtrim(ltrim(ifnull(Par_SegundoApellido, '')))) > 0 then concat(" ", rtrim(ltrim(ifnull(Par_SegundoApellido, '')))) else '' end
								);

		  UPDATE BENEFICIARIOSINVER Set
					BenefInverID    = Par_BenefInverID,
					InversionID     = Par_InversionID,
					ClienteID       = Par_ClienteID,
					Titulo          = Par_Titulo,
					PrimerNombre    = Par_PrimerNombre,
					SegundoNombre   = Par_SegundoNombre,
					TercerNombre    = Par_TercerNombre,
					PrimerApellido  = Par_PrimerApellido,
					SegundoApellido = Par_SegundoApellido,
					FechaNacimiento = Par_FechaNacimiento,
					PaisID          = Par_PaisID,
					EstadoID        = Par_EstadoID,
					EstadoCivil     = Par_EstadoCivil,
					Sexo            = Par_Sexo,
					CURP            = Par_CURP,
					RFC             = Par_RFC,
					OcupacionID     = Par_OcupacionID,
					ClavePuestoID   = Par_ClavePuestoID,
					TipoIdentiID    = Par_TipoIdentiID,
					NumIdentific    = Par_NumIdentific,
					FecExIden       = Par_FecExIden,
					FecVenIden      = Par_FecVenIden,
					TelefonoCasa    = Par_TelefonoCasa,
					TelefonoCelular = Par_TelefonoCelular,
					Correo          = Par_Correo,
					Domicilio       = Par_Domicilio,
					TipoRelacionID  = Par_TipoRelacionID,
					Porcentaje      = Par_Porcentaje,
					NombreCompleto  = Var_NombreCompleto,
					EmpresaID			= Par_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion

			where InversionID		= Par_InversionID
			and BenefInverID = Par_BenefInverID ;

            SET Par_NumErr  := '000';
            SET Par_ErrMen  := concat('Beneficiario Modificado Exitosamente: ', Par_BenefInverID );
            SET varControl  := 'beneInverID' ;
        ELSE
                UPDATE BENEFICIARIOSINVER SET
                        TipoRelacionID  = Par_TipoRelacionID,
                        Porcentaje      = Par_Porcentaje

                        where InversionID   = Par_InversionID
                        and ClienteID       = Par_ClienteID ;

            SET Par_NumErr  :='000';
            SET Par_ErrMen  := concat('Beneficiario Modificado Exitosamente: ', Par_BenefInverID );
            SET varControl  := 'beneInverID';
        END IF;

END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
            SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen			 AS ErrMen,
            varControl			 AS control,
			Par_BenefInverID	    AS consecutivo;
        end IF;


END TerminaStore$$