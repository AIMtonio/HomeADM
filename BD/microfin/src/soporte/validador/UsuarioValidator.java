package soporte.validador;

import org.springframework.validation.Errors;
import org.springframework.validation.ValidationUtils;
import org.springframework.validation.Validator;

import soporte.bean.UsuarioBean;


public class UsuarioValidator implements Validator{
	
	
	public boolean supports(Class clazz) {
		return clazz.equals(UsuarioBean.class);
	}
	
	public void validate(Object command, Errors errors) {
		ValidationUtils.rejectIfEmpty(
				errors, "clave", "required.clave",
				"Clave Requerida.");
		
		
	}
}
