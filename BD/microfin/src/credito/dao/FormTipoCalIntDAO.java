package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import originacion.bean.CreditosPlazosBean;

import cliente.bean.ClienteBean;

import credito.bean.FormTipoCalIntBean;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class FormTipoCalIntDAO extends BaseDAO {
	public FormTipoCalIntDAO() {
		super();
	}
	
	public FormTipoCalIntBean consultaPrincipal(FormTipoCalIntBean formTipoCalInt, int tipoConsulta) {

		//Query con el Store Procedure
		String query = "call FORMTIPOCALINTCON(?,? ,?,?,?,?,?,?,?);";
		Object[] parametros = { 
								formTipoCalInt.getFormInteresID(),
								tipoConsulta,			
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TasasBaseDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASBASECON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FormTipoCalIntBean formTipoCalInt = new FormTipoCalIntBean();
				formTipoCalInt.setFormInteresID(resultSet.getString(1)); 
				formTipoCalInt.setFormula(resultSet.getString(2)); 
				formTipoCalInt.setEmpresaID(resultSet.getString(3));
				return formTipoCalInt;
			}
		});
		return matches.size() > 0 ? (FormTipoCalIntBean) matches.get(0) : null;
	}
	
	
	public List listaFormCalInt(FormTipoCalIntBean tipoCalInt, int tipoLista){
		String query = "call FORMTIPOCALINTLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
					tipoCalInt.getFormula(),
					tipoLista,
					
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"TasasBaseDAO.listaTasasBase",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
					};
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TASASBASELIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FormTipoCalIntBean tipoCalInt = new FormTipoCalIntBean();
				tipoCalInt.setFormInteresID(resultSet.getString(1)); 
				tipoCalInt.setFormula(resultSet.getString(2));
				return tipoCalInt;
			}
		});
		return matches;
	}
	
	//Lista de Plazos para Combo Box	
	public List listaCombo(FormTipoCalIntBean formTipoCalInt, int tipoLista) {
		//Query con el Store Procedure
		String query = "call FORMTIPOCALINTLIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {	Constantes.STRING_VACIO,
								tipoLista,
								
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								Constantes.STRING_VACIO,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call FORMTIPOCALINTLIS(" + Arrays.toString(parametros) +")");
		
	List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				FormTipoCalIntBean tipoCalInt = new FormTipoCalIntBean();
				tipoCalInt.setFormInteresID(resultSet.getString(1)); 
				tipoCalInt.setFormula(resultSet.getString(2));
				return tipoCalInt;				
			}
		});
				
		return matches;
	}

}
