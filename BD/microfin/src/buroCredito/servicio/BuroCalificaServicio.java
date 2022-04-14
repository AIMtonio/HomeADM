package buroCredito.servicio;

import java.io.BufferedWriter;
import java.io.FileInputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;

import pld.servicio.NivelRiesgoClienteServicio.Enum_Tipo_Reporte;

import buroCredito.bean.BuroCalificaBean;
import buroCredito.dao.BuroCalificaDAO;
import general.servicio.BaseServicio;

public class BuroCalificaServicio extends BaseServicio{
	BuroCalificaDAO buroCalificaDAO = null;

	public static interface Enum_Tipo_Reporte {
		int reporteFIRA = 1;
	}
	
	
	public List<BuroCalificaBean> listaBuroCalifica(int tipoReporte, BuroCalificaBean buroCalificaBean, HttpServletResponse response){
		List<BuroCalificaBean> listaRepBuroCalifica = null;
		
		switch (tipoReporte) {
		case Enum_Tipo_Reporte.reporteFIRA:
			listaRepBuroCalifica = generaReporteTXT(tipoReporte, buroCalificaBean, response);
			break;
		}
		return listaRepBuroCalifica;
	}
	
		
	public List<BuroCalificaBean> generaReporteTXT(int tipoReporte, BuroCalificaBean buroCalifica, HttpServletResponse response){
		
		String nombreArchivo = "buroCalifica_";
		
		if(buroCalifica.getRangoCartera().equals("T"))
			nombreArchivo = nombreArchivo + "TotalCartera";
		else{
			nombreArchivo = nombreArchivo + "Periodo_" + buroCalifica.getPeriodo().substring(0,4) + "_" + buroCalifica.getPeriodo().substring(5,7);
		}
		
		nombreArchivo = nombreArchivo + ".txt";

		
		 List<BuroCalificaBean> listaBuroCalifica = buroCalificaDAO.listaBuroCalifica(buroCalifica, tipoReporte);
		
		try {
			BufferedWriter writer = new BufferedWriter(new FileWriter(nombreArchivo));
			if(!listaBuroCalifica.isEmpty()){
				for(int i = 0; i<listaBuroCalifica.size(); i++){
					writer.write(i+1 + "|");
					writer.write(listaBuroCalifica.get(i).getReferenciaConsultado() + "|" +
								listaBuroCalifica.get(i).getTipoCliente() + "|" +
								listaBuroCalifica.get(i).getRfc() + "|" +
								listaBuroCalifica.get(i).getNombre() + "|" +
								listaBuroCalifica.get(i).getSegundoNombre() + "|" +
								listaBuroCalifica.get(i).getApellidoPaterno() + "|" +
								listaBuroCalifica.get(i).getApellidoMaterno() + "|" +
								listaBuroCalifica.get(i).getFechaNacimiento() + "|" +
								listaBuroCalifica.get(i).getCurp() + "|" +
								listaBuroCalifica.get(i).getCalleNum() + "|" +
								listaBuroCalifica.get(i).getCalleNumDOS() + "|" +
								listaBuroCalifica.get(i).getColonia() + "|" +
								listaBuroCalifica.get(i).getMunicipio() + "|" +
								listaBuroCalifica.get(i).getCiudad() + "|" +
								listaBuroCalifica.get(i).getEstado() + "|" +
								listaBuroCalifica.get(i).getCodigoPostal() + "|" +
								listaBuroCalifica.get(i).getPaisOrigen() + "|" +
								listaBuroCalifica.get(i).getReferenciaCrediticia() + "\n");
				}
				
			}else{
				writer.write("");
			}
			writer.close();
			
			FileInputStream archivo = new FileInputStream(nombreArchivo);
			int longitud = archivo.available();
			byte[] datos = new byte[longitud];
			archivo.read(datos);
			archivo.close();

			response.setHeader("Content-Disposition", "attachment;filename=" + nombreArchivo);
			response.setContentType("application/text");
			ServletOutputStream outputStream = response.getOutputStream();
			outputStream.write(datos);
			outputStream.flush();
			outputStream.close();

		}
		catch (IOException io) {
			loggerSAFI.info("Ocurrió un error al tratar de escribir el archivo - BuroCalificaServicio.generaReporteTXT");
			io.printStackTrace();
		}
		catch(Exception e){
			loggerSAFI.info("Ocurrió un error al tratar de generar el archivo - BuroCalificaServicio.generaReporteTXT");
			e.printStackTrace();
		}
	
	return null;
}
	
	
	
	public BuroCalificaDAO getBuroCalificaDAO() {
		return buroCalificaDAO;
	}

	public void setBuroCalificaDAO(BuroCalificaDAO buroCalificaDAO) {
		this.buroCalificaDAO = buroCalificaDAO;
	}
}
