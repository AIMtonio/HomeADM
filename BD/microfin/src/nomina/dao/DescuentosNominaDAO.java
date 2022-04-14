package nomina.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;
import org.springframework.jdbc.core.RowMapper;
import nomina.bean.EmpleadoNominaBean;
 
public class DescuentosNominaDAO extends BaseDAO{
	public DescuentosNominaDAO() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Lista de Creditos para Descuentos de Nomina
		public List listaDescuentoNomina(int tipoLista,final EmpleadoNominaBean empleadoNominaBean){
			String query = "call CREDITONOMINABEREP(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(empleadoNominaBean.getInstitNominaID()),
					tipoLista,
			
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CreditosDAO.listaDescuentoNominaWS",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITONOMINABEREP(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
		public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
			EmpleadoNominaBean empleadoNominaBean = new EmpleadoNominaBean();
			
			empleadoNominaBean.setFolioCtrl(resultSet.getString("FolioCtrl"));
			empleadoNominaBean.setNombreCompleto(resultSet.getString("NombreCompleto"));
			empleadoNominaBean.setMontoCuota(resultSet.getString("MontoPago"));
			empleadoNominaBean.setPlazo(resultSet.getString("Plazo"));
			empleadoNominaBean.setNombreInstNomina(resultSet.getString("NombreInstitucion"));
			empleadoNominaBean.setNumPago(resultSet.getString("NumPago"));
			empleadoNominaBean.setFechaPago(resultSet.getString("FechaExigible"));
			empleadoNominaBean.setCreditoID(resultSet.getString("CreditoID"));
			empleadoNominaBean.setHoraEmision(resultSet.getString("HoraEmision"));
			empleadoNominaBean.setMontoAtraso(resultSet.getString("MontoAtraso"));
			empleadoNominaBean.setMontoExigible(resultSet.getString("MontoExigible"));
			empleadoNominaBean.setAdeudoTotal(resultSet.getString("AdeudoTotal"));
			empleadoNominaBean.setMontoTotal(resultSet.getString("MontoTotal"));
			empleadoNominaBean.setMontoAccesorio(resultSet.getString("Accesorios"));
			empleadoNominaBean.setInteresAccesorios(resultSet.getString("InteresAccesorio"));
			empleadoNominaBean.setIvaInteresAccesorios(resultSet.getString("IvaInteresAccesorio"));	
			
				return empleadoNominaBean;
				}
		});
			return matches;
		}

}
