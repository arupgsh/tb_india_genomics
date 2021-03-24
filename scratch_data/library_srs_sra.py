#import xml.etree.ElementTree as ET
#from xml.etree import ElementTree
import sys
import re
import requests
#from progress.bar import IncrementalBar

def parse_response(ncbi_id, response) -> str:
#source: https://github.com/farhat-lab/metatools_ncbi/blob/0601e09982d1748c941fa25515518056017d1f0e/metatools_ncbi/convert_to_biosample.py#L25
    biosample=""
    samplename=""
    run=""
    layout=""
    biosamples_found=[]
    samplename_found=[]
    run_found=[]
    layout_found=[]
    lines=response.split("\n")
    header=lines.pop(0)
    idx_biosample=header.split(",").index("BioSample")
    idx_samplename=header.split(",").index("SampleName")
    idx_run=header.split(",").index("Run")
    idx_layout=header.split(",").index("LibraryLayout")

    for line in lines:
        if line == "":
            continue
        biosamples_found.append(line.split(",")[idx_biosample])
        samplename_found.append(line.split(",")[idx_samplename])
        run_found.append(line.split(",")[idx_run])
        layout_found.append(line.split(",")[idx_layout])
    n_biosamples_found=len(set(biosamples_found))
    if n_biosamples_found == 1 :
        biosample=set(biosamples_found).pop()
        samplename=set(samplename_found).pop()
        run=set(run_found).pop()
        layout=set(layout_found).pop()
    sampledetails = samplename+','+run+','+biosample+','+layout
    return(sampledetails)

with open(sys.argv[1],'r') as f:
    for line in f:
        line = line.strip('\n').split('\t')
        #print(line[2])
        list_of_biosamples=[]
        db = "sra"
        request = "http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&db={}&rettype=runinfo&term={}".format(db,line[2])
        #print(request)
        response = requests.get(url=request,stream=True)
        response.encoding = 'utf-8'
        biosample=parse_response(line[2], response.text)
        list_of_biosamples.append(biosample)
        #sample = ','.join(list_of_biosamples)
        #output = l+','+n+','+sample
        print('\n'.join(list_of_biosamples))


# # create element tree object
# tree = ET.parse(sys.argv[1])
# # get root element
# root = tree.getroot()

# for item in root:
#     list_of_biosamples=[]
#     n = item.find('.//Id[@db="SRA"]').text
#     l = item.find('.//Id[@db_label="Sample name"]').text
#     #print(l,n)
#     db = "sra"
#     request = "http://trace.ncbi.nlm.nih.gov/Traces/sra/sra.cgi?save=efetch&db={}&rettype=runinfo&term={}".format(db, n)
#     #print(request)
#     response = requests.get(url=request,stream=True)
#     response.encoding = 'utf-8'
#     biosample=parse_response(n, response.text)
#     list_of_biosamples.append(biosample)
#     sample = ','.join(list_of_biosamples)
#     output = l+','+n+','+sample
#     print(output)