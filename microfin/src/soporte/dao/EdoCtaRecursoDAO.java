package soporte.dao;

import soporte.bean.CompaniasBean;
import soporte.bean.GeneraEdoCtaBean;
import soporte.servicio.CompaniasServicio;
import soporte.servicio.InstitucionesServicio;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import java.sql.SQLException;
import java.util.Arrays;
import java.util.List;	
import java.sql.ResultSet;
 
import org.springframework.jdbc.core.RowMapper;

public class EdoCtaRecursoDAO extends BaseDAO{
	
	CompaniasBean companiasBean = null;
	CompaniasServicio companiasServicio = null;
	
	public EdoCtaRecursoDAO(){
		super();
	}
	
	public List<GeneraEdoCtaBean> consultaDirec() {
		
		//Se consulta el prefijo de la empresa necesario para la creacion de directorios
		int CON_Prefijo = 1; // Consulta del prefijo
		CompaniasBean prefijoEmpresa = companiasServicio.consulta(CON_Prefijo, companiasBean);
		
		String query = "call EDOCTACREADIREC( ? );";
		Object[] parametros = {	prefijoEmpresa.getDesplegado().replaceAll("\\s", "") };	
		
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTACREADIREC(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GeneraEdoCtaBean generaEdoCta = new GeneraEdoCtaBean();
				generaEdoCta.setRutaEdoCtaPDF(resultSet.getString("cmd"));
				return generaEdoCta;
			}
		});
		return matches;
	}	
		
	public CompaniasServicio getCompaniasServicio() {
		return companiasServicio;
	}
	
	public void setCompaniasServicio(CompaniasServicio companiasServicio) {
		this.companiasServicio = companiasServicio;
	}
	
}
